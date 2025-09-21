local M = {}

local throttle_ms = 50 -- min delay between successive next/prev
local debounce_ms = 120 -- rebuild debounce after edits
local viewport_margin = 50 -- extra lines around the visible window
local bigfile_lines = 5000 -- above this, we only ever process the viewport
local max_scan_cols = 2000 -- hard cap on per-line char scanning

local function hrtime_ms()
	return vim.loop.hrtime() / 1e6
end

local function visible_range()
	local top = vim.fn.line("w0") - 1
	local bot = vim.fn.line("w$") - 1
	return top, bot
end

local function clamp(n, lo, hi)
	if n < lo then
		return lo
	end
	if n > hi then
		return hi
	end
	return n
end

local function goto_pos(r, c)
	-- r is 0-based, API is 1-based
	pcall(vim.api.nvim_win_set_cursor, 0, { r + 1, c })
end

local function get_cursor_pos()
	local pos = vim.api.nvim_win_get_cursor(0)
	return pos[1] - 1, pos[2]
end

-- ===== State ================================================================

local state = {
	waypoints = nil, -- cached sorted { {r,c}, ... }
	last_tick = -1, -- buffer changedtick at which waypoints were built
	in_jump = false, -- reentrancy guard
	last_call = 0, -- last next/prev call time (ms)
}

-- Separate cache for the raw char scan (expensive); bound to changedtick
local char_cache = {
	tick = -1,
	items = {}, -- { {r,c}, ... }
}

-- ===== Character-based waypoint collection ==================================

local function collect_char_waypoints(range_top, range_bot)
	local tick = vim.b.changedtick or 0
	if char_cache.tick == tick and char_cache.items then
		local filtered = {}
		for i = 1, #char_cache.items do
			local r, c = char_cache.items[i][1], char_cache.items[i][2]
			if r >= range_top and r <= range_bot then
				filtered[#filtered + 1] = { r, c }
			end
		end
		return filtered
	end

	local items = {}

	local closing_chars = {
		[")"] = true,
		["]"] = true,
		["}"] = true,
	}

	local quotes = {
		['"'] = true,
		["'"] = true,
		["`"] = true,
	}

	local operators = {
		[","] = true,
		[">"] = true,
		["+"] = true,
		["-"] = true,
		["*"] = true,
		["/"] = true,
		["%"] = true,
		["&"] = true,
		["|"] = true,
		["="] = true,
		["^"] = true,
		["!"] = true,
	}

	-- Scan lines for jump targets
	for row = range_top, range_bot do
		local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
		if line then
			local len = math.min(#line, max_scan_cols)
			local in_string = false
			local string_char = nil

			for col = 0, len - 1 do
				local ch = string.sub(line, col + 1, col + 1)

				-- Handle quotes specially - jump to inside AND after closing quotes
				if quotes[ch] then
					if not in_string then
						in_string = true
						string_char = ch
					elseif ch == string_char then
						items[#items + 1] = { row, col } -- Inside the quote
						items[#items + 1] = { row, col + 1 } -- Outside the quote
						in_string = false
						string_char = nil
					end
				-- Handle closing brackets - jump after them
				elseif closing_chars[ch] and not in_string then
					items[#items + 1] = { row, col + 1 }
				-- Handle operators - jump after them
				elseif operators[ch] and not in_string then
					items[#items + 1] = { row, col + 1 }
				end
			end
		end
	end

	char_cache.tick = tick
	char_cache.items = items
	return items
end

-- ===== Waypoint collection ==================================================

local function collect_waypoints()
	local total_lines = vim.api.nvim_buf_line_count(0)
	local top, bot = visible_range()
	local margin = viewport_margin

	-- For big files, restrict to viewport only (with margin).
	if total_lines > bigfile_lines then
		margin = math.min(margin, 200)
	end

	local range_top = clamp(top - margin, 0, total_lines - 1)
	local range_bot = clamp(bot + margin, 0, total_lines - 1)

	local waypoints = {}

	-- Always collect character-based waypoints (works without treesitter)
	local char_waypoints = collect_char_waypoints(range_top, range_bot)
	for i = 1, #char_waypoints do
		waypoints[#waypoints + 1] = char_waypoints[i]
	end

	-- Try to add treesitter waypoints if available
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if ok and parser then
		local trees = parser:parse()
		if trees and #trees > 0 then
			local root = trees[1]:root()

			local function push(out, r, c)
				if r and c and r >= range_top and r <= range_bot and r >= 0 and c >= 0 then
					out[#out + 1] = { r, c }
				end
			end

			local function nr4(n)
				if not n then
					return 0, 0, 0, 0
				end
				local r1, c1, r2, c2 = n:range()
				return r1, c1, r2 or r1, c2 or c1
			end

			local target_types = {
				identifier = true,
				property_identifier = true,
				field_identifier = true,
				number_literal = true,
				true_literal = true,
				false_literal = true,
				primitive_type = true,
				type_identifier = true,
				sized_type_specifier = true,
			}

			local container_types = {
				parameter_list = true,
				argument_list = true,
				formal_parameters = true,
				parameters = true,
				compound_statement = true,
				statement_block = true,
				block = true,
			}

			local function is_modifier_like(t)
				return t:match("specifier")
					or t:match("qualifier")
					or t:match("modifier")
					or t:match("keyword")
					or t == "storage_class_specifier"
					or t == "type_qualifier"
					or t == "cv_qualifier"
					or t == "virtual_specifier"
					or t == "explicit_function_specifier"
			end

			-- Walk only nodes intersecting [range_top, range_bot]
			local function walk(node)
				if not node then
					return
				end
				local sr, sc, er, ec = nr4(node)
				if er < range_top or sr > range_bot then
					return
				end

				local t = node:type()

				if t:match("declaration") or t:match("definition") then
					for child in node:iter_children() do
						if child:named() then
							local ct = child:type()
							if target_types[ct] or is_modifier_like(ct) then
								local cr, cc = nr4(child)
								push(waypoints, cr, cc)
								break
							end
						end
					end
				end

				if target_types[t] then
					push(waypoints, er, ec)
				end

				if is_modifier_like(t) then
					push(waypoints, er, ec)
				end

				if container_types[t] then
					push(waypoints, sr, sc + 1)
					push(waypoints, er, ec)
				end

				if t:match("parenthesized") or t:match("condition") then
					push(waypoints, sr, sc + 1)
					push(waypoints, er, ec)
				end

				if t:match("statement") or t:match("expression") then
					push(waypoints, er, ec)
				end

				for child in node:iter_children() do
					if child:named() then
						walk(child)
					end
				end
			end

			walk(root)
		end
	end

	-- Sort + dedupe
	table.sort(waypoints, function(a, b)
		return (a[1] < b[1]) or (a[1] == b[1] and a[2] < b[2])
	end)

	local deduped, lr, lc = {}, -1, -1
	for _, wp in ipairs(waypoints) do
		if wp[1] ~= lr or wp[2] ~= lc then
			deduped[#deduped + 1] = wp
			lr, lc = wp[1], wp[2]
		end
	end

	return deduped
end

-- ===== Cache access (no rebuild on cursor move) =============================

local function get_waypoints()
	local tick = vim.b.changedtick or 0
	if state.waypoints and state.last_tick == tick then
		return state.waypoints
	end
	state.waypoints = collect_waypoints()
	state.last_tick = tick
	return state.waypoints
end

-- ===== Debounced rebuild on edits ==========================================

local timer = vim.loop.new_timer()

local function schedule_rebuild()
	timer:stop()
	timer:start(debounce_ms, 0, function()
		vim.schedule(function()
			if state.in_jump then
				return
			end
			state.waypoints = collect_waypoints()
			state.last_tick = vim.b.changedtick or 0
		end)
	end)
end

-- Define augroup before using it
local aug = vim.api.nvim_create_augroup("SmartSemanticCycle", { clear = true })

-- Only invalidate & rebuild on real text changes (not on cursor move)
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
	group = aug,
	callback = function()
		-- Mark dirty; let the debounced builder refresh the cache
		state.waypoints = nil
		state.last_tick = -1
		schedule_rebuild()
	end,
})

-- ===== Public API: next / prev =============================================

function M.next()
	local now = hrtime_ms()
	if (now - state.last_call) < throttle_ms then
		return
	end
	state.last_call = now

	if state.in_jump then
		return
	end
	state.in_jump = true

	local wps = get_waypoints()
	if #wps == 0 then
		state.in_jump = false
		return
	end

	local cr, cc = get_cursor_pos()
	local target

	-- pick first waypoint strictly after cursor
	for i = 1, #wps do
		local r, c = wps[i][1], wps[i][2]
		if (r > cr) or (r == cr and c > cc) then
			target = wps[i]
			break
		end
	end
	if not target then
		target = wps[1]
	end

	if target then
		goto_pos(target[1], target[2])
	end

	vim.schedule(function()
		state.in_jump = false
	end)
end

function M.prev()
	if state.in_jump then
		return
	end
	state.in_jump = true

	local wps = get_waypoints()
	if #wps == 0 then
		state.in_jump = false
		return
	end

	local cr, cc = get_cursor_pos()
	local target

	for i = #wps, 1, -1 do
		local r, c = wps[i][1], wps[i][2]
		if (r < cr) or (r == cr and c < cc) then
			target = wps[i]
			break
		end
	end
	if not target then
		target = wps[#wps]
	end

	if target then
		goto_pos(target[1], target[2])
	end

	vim.schedule(function()
		state.in_jump = false
	end)
end

return M

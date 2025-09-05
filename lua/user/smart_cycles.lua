local M = {}
local last_call = 0
local throttle_ms = 50

local function goto_pos(r, c)
	vim.api.nvim_win_set_cursor(0, { r + 1, c })
end

local function get_cursor_pos()
	local pos = vim.api.nvim_win_get_cursor(0)
	return pos[1] - 1, pos[2]
end

local function collect_waypoints()
	local parser = vim.treesitter.get_parser(0)
	if not parser then
		return {}
	end
	local trees = parser:parse()
	if not trees or #trees == 0 then
		return {}
	end
	local root = trees[1]:root()

	local waypoints = {}

	local function push(out, r, c)
		if r and c and r >= 0 and c >= 0 then
			table.insert(out, { r, c })
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

	local function walk(node)
		if not node then
			return
		end
		local t = node:type()
		local sr, sc, er, ec = nr4(node)

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

	local function collect_raw_jump_chars()
		local buf = 0
		local total_lines = vim.api.nvim_buf_line_count(buf)
		local jump_chars = {
			[")"] = true,
			["]"] = true,
			["}"] = true,
			['"'] = true,
			["'"] = true,
			["`"] = true,
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

		local one_after_symbols = {
			[")"] = true,
			["]"] = true,
			["}"] = true,
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

		for row = 0, total_lines - 1 do
			local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
			if line then
				for col = 0, #line - 1 do
					local ch = line:sub(col + 1, col + 1)
					if jump_chars[ch] then
						if one_after_symbols[ch] then
							push(waypoints, row, col + 1)
						else
							push(waypoints, row, col)
						end
					end
				end
			end
		end
	end

	collect_raw_jump_chars()

	table.sort(waypoints, function(a, b)
		return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
	end)
	local deduped, lr, lc = {}, -1, -1
	for _, wp in ipairs(waypoints) do
		if wp[1] ~= lr or wp[2] ~= lc then
			table.insert(deduped, wp)
			lr, lc = wp[1], wp[2]
		end
	end

	return deduped
end

local state = {
	waypoints = nil,
	last_tick = -1,
	in_jump = false,
}

local function get_waypoints()
	local tick = vim.b.changedtick or 0
	if state.waypoints and state.last_tick == tick then
		return state.waypoints
	end
	state.waypoints = collect_waypoints()
	state.last_tick = tick
	return state.waypoints
end

function M.next()
	local now = vim.loop.hrtime() / 1000000 -- Convert to ms
	if now - last_call < throttle_ms then
		return
	end
	last_call = now

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
	for _, wp in ipairs(wps) do
		local r, c = wp[1], wp[2]
		if r > cr or (r == cr and c > cc) then
			target = wp
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
		if r < cr or (r == cr and c < cc) then
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

local aug = vim.api.nvim_create_augroup("SmartSemanticCycle", { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "CursorMoved", "CursorMovedI" }, {
	group = aug,
	callback = function()
		if not state.in_jump then
			state.waypoints = nil
			state.last_tick = -1
		end
	end,
})

return M

vim.g.fast_cursor_move_acceleration = true
local fn = vim.fn
local api = vim.api

local ACCELERATION_LIMIT = 150
local ACCELERATION_TABLE_VERTICAL = { 7, 14, 20, 26, 31, 36, 40 }
local ACCELERATION_TABLE_HORIZONTAL = { 10, 15, 20 }

local get_move_step = (function()
	local prev_direction
	local prev_time = 0
	local move_count = 0

	return function(direction)
		if vim.g.fast_cursor_move_acceleration == false then
			return 1
		end

		if direction ~= prev_direction then
			prev_time = 0
			move_count = 0
			prev_direction = direction
		else
			local time = vim.loop.hrtime()
			local elapsed = (time - prev_time) / 1e6
			if elapsed > ACCELERATION_LIMIT then
				move_count = 0
			else
				move_count = move_count + 1
			end
			prev_time = time
		end

		local acceleration_table = (
			(direction == "u" or direction == "h") and ACCELERATION_TABLE_VERTICAL or ACCELERATION_TABLE_HORIZONTAL
		)

		for idx, count in ipairs(acceleration_table) do
			if move_count < count then
				return idx
			end
		end
		return #acceleration_table
	end
end)()

local function get_move_chars(direction)
	local move_map = {
		k = "h",
		u = "gj",
		l = "gk",
		h = "l",
	}
	return move_map[direction] or direction
end

local function move(direction)
	local move_chars = get_move_chars(direction)

	if fn.reg_recording() ~= "" or fn.reg_executing() ~= "" then
		return move_chars
	end

	local is_normal = api.nvim_get_mode().mode:lower() == "n"
	if not is_normal then
		return move_chars
	end

	if vim.v.count > 0 then
		return move_chars
	end

	local step = get_move_step(direction)
	return step .. move_chars
end

local function setup()
	for _, motion in ipairs({ "k", "u", "h", "l" }) do
		vim.keymap.set({ "n", "v" }, motion, function()
			return move(motion)
		end, { expr = true, desc = "Fast cursor move " .. motion })
	end
end

vim.defer_fn(setup, 500)

vim.keymap.set("n", "<leader>ta", function()
	vim.g.fast_cursor_move_acceleration = not vim.g.fast_cursor_move_acceleration
	local status = vim.g.fast_cursor_move_acceleration and "ON" or "OFF"
	print("Fast cursor acceleration: " .. status)
end, { desc = "Toggle cursor acceleration" })

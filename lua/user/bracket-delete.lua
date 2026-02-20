local M = {}

local function get_autopairs_rules()
	local ok, autopairs = pcall(require, "nvim-autopairs")
	if not ok then
		vim.notify("nvim-autopairs not found", vim.log.levels.ERROR)
		return {}
	end

	local rules = autopairs.get_rules()
	local pair_map = {}

	for _, rule in ipairs(rules) do
		if rule.start_pair and rule.end_pair then
			pair_map[rule.start_pair] = rule.end_pair
		end
	end

	return pair_map
end

local function find_enclosing_pair()
	local pair_map = get_autopairs_rules()
	print(pair_map)

	local best_open = nil
	local best_close = nil
	local best_dist = math.huge

	for open_char, close_char in pairs(pair_map) do
		local open_pos = vim.fn.searchpairpos(vim.pesc(open_char), "", vim.pesc(close_char), "bnW")
		local close_pos = vim.fn.searchpairpos(vim.pesc(open_char), "", vim.pesc(close_char), "nW")

		if open_pos[1] > 0 and close_pos[1] > 0 then
			local dist = (close_pos[1] - open_pos[1]) * 1000 + (close_pos[2] - open_pos[2])
			if dist < best_dist then
				best_dist = dist
				best_open = open_pos
				best_close = close_pos
			end
		end
	end

	return best_open, best_close
end

function M.delete_closing()
	print("delete_closing called")
	local _, close_pos = find_enclosing_pair()
	print("close_pos:", vim.inspect(close_pos))
	if close_pos then
		local save_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { close_pos[1], close_pos[2] - 1 })
		vim.cmd("normal! x")
		-- adjust saved position if needed
		if save_pos[1] == close_pos[1] and save_pos[2] >= close_pos[2] then
			save_pos[2] = save_pos[2] - 1
		end
		vim.api.nvim_win_set_cursor(0, save_pos)
	else
		print("no close_pos found")
	end
end

function M.delete_opening()
	print("delete_opening called")
	local open_pos, _ = find_enclosing_pair()
	print("open_pos:", vim.inspect(open_pos))
	if open_pos then
		local save_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { open_pos[1], open_pos[2] - 1 })
		vim.cmd("normal! x")
		-- adjust saved position if needed
		if save_pos[1] == open_pos[1] and save_pos[2] > open_pos[2] then
			save_pos[2] = save_pos[2] - 1
		end
		vim.api.nvim_win_set_cursor(0, save_pos)
	else
		print("no open_pos found")
	end
end

-- Auto-setup keymaps on require
print("Setting up bracket-delete keymaps...")
vim.keymap.set("n", "dc", M.delete_closing, { desc = "Delete closing bracket" })
print("dc keymap set")
vim.keymap.set("n", "do", M.delete_opening, { desc = "Delete opening bracket" })
print("do keymap set")

return M

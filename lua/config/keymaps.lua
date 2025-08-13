-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "j", "u", { noremap = true, silent = true, desc = "Undo" })
keymap("n", "J", "<C-r>", { noremap = true, silent = true, desc = "Redo" })

keymap("n", "<S-k>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<S-u>", "<C-w>j", { desc = "Move to split below" })
keymap("n", "<S-l>", "<C-w>k", { desc = "Move to split above" })
keymap("n", "<S-h>", "<C-w>l", { desc = "Move to right split" })

keymap("n", "<C-A-k>", ":vertical resize -2<CR>", { desc = "Resize split left" })
keymap("n", "<C-A-u>", ":resize +2<CR>", { desc = "Resize split down" })
keymap("n", "<C-A-l>", ":resize -2<CR>", { desc = "Resize split up" })
keymap("n", "<C-A-h>", ":vertical resize +2<CR>", { desc = "Resize split right" })

keymap("n", "<A-K>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-U>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-L>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-H>", "<C-w>L", { desc = "Move window right" })

keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- Window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close window" })

keymap("n", "<A-h>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<A-k>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<A-w>", "<Cmd>bdelete<CR>", { silent = true })

keymap("n", "<A-l>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("n", "<A-u>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("v", "<A-l>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-u>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })

-- Save file
keymap({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
keymap("i", "<S-CR>", 'copilot#Accept("")', { expr = true, silent = true, noremap = true, replace_keycodes = true })

vim.keymap.set("i", "<Esc>[13;2u", function()
	if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
		return vim.fn["copilot#Accept"]("")
	else
		return "<CR>"
	end
end, { expr = true, silent = true, noremap = true, replace_keycodes = false, desc = "Accept Copilot with Shift+Enter" })

keymap("i", "<S-CR>", function()
	if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
		return vim.fn["copilot#Accept"]("")
	else
		return "<CR>"
	end
end, { expr = true, silent = true, noremap = true, replace_keycodes = false, desc = "Accept Copilot or newline" })

-- Smart jump that considers nested structures
--
--

local function smart_jump_forward()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	local total_lines = vim.api.nvim_buf_line_count(0)
	local pairs = {
		["("] = ")",
		["["] = "]",
		["{"] = "}",
		['"'] = '"',
		["'"] = "'",
		["`"] = "`",
		["<"] = ">",
	}
	local closing_chars = { ")", "]", "}", '"', "'", "`", ">" }
	local stack = {}
	-- Get all text from cursor to end of buffer
	local lines = vim.api.nvim_buf_get_lines(0, row - 1, total_lines, false)
	local start_col = (row == cursor[1]) and col + 1 or 1
	for line_idx, line in ipairs(lines) do
		local actual_row = row - 1 + line_idx
		local start_pos = (line_idx == 1) and start_col or 1
		for i = start_pos, #line do
			local char = line:sub(i, i)
			-- If it's an opening character, push to stack
			if pairs[char] then
				table.insert(stack, pairs[char])
			-- If it's a closing character
			elseif vim.tbl_contains(closing_chars, char) then
				if #stack > 0 and stack[#stack] == char then
					-- Matching pair, pop from stack
					table.remove(stack)
				else
					-- Unmatched closing char or empty stack - jump here
					vim.api.nvim_win_set_cursor(0, { actual_row, i })
					return
				end
			end
		end
	end
	vim.notify("No unmatched closing character found", vim.log.levels.INFO)
end

-- Enhanced backward jump that can skip nearby opening chars
local function smart_jump_backward()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	local opening_chars = { "(", "[", "{", '"', "'", "`", "<" }

	-- Check if we're immediately after an opening character
	local current_line = vim.api.nvim_get_current_line()
	local skip_nearby = false

	-- Check if the character right before cursor is an opening char
	if col > 0 then
		local prev_char = current_line:sub(col, col)
		if vim.tbl_contains(opening_chars, prev_char) then
			skip_nearby = true
		end
	end

	-- Search backward through all lines
	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
	local found_first = false

	-- Start from current position and go backward
	for line_idx = #lines, 1, -1 do
		local line = lines[line_idx]
		local end_pos = (line_idx == #lines) and col or #line

		for i = end_pos, 1, -1 do
			local char = line:sub(i, i)
			if vim.tbl_contains(opening_chars, char) then
				if skip_nearby and not found_first then
					-- Skip the first opening character found if it's nearby
					found_first = true
				else
					-- Jump to this opening character
					vim.api.nvim_win_set_cursor(0, { line_idx, i - 1 })
					return
				end
			end
		end
	end

	vim.notify("No opening character found", vim.log.levels.INFO)
end

-- Bind the functions
vim.keymap.set("i", "<D-;>", smart_jump_forward, { desc = "Smart jump out forward" })

vim.keymap.set("i", "<D-S-;>", smart_jump_backward, { desc = "Smart jump out backward" })

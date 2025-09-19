--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- undo/redo (normal)
keymap("n", "j", "u", opts)
keymap("n", "J", "<C-r>", opts)

-- join with line above
keymap("n", "Y", "mzJ`z", opts)

-- move with middle
keymap("n", "<C-l>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- keep in the middle of screen
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- useless
keymap("n", "Q", "<nop>")
-- quick chmod +x
keymap("n", "<leader> ch", "<cmd>!chmod +x %<CR>", { silent = true })

-- move around with ctrl (insert) (start of line, end of line, up down)
keymap("i", "<C-k>", "<C-o>^", opts)
keymap("i", "<C-u>", "<Down>", opts)
keymap("i", "<C-h>", "<C-o>$", opts)
keymap("i", "<C-l>", "<Up>", opts)
keymap("i", "<D-BS>", "<C-u>", opts)

-- move around with alt (insert)
keymap("i", "<A-l>", "<Up>", opts)
keymap("i", "<A-u>", "<Down>", opts)
keymap("i", "<A-k>", "<Left>", opts)
keymap("i", "<A-h>", "<Right>", opts)

-- move around splits (normal)
keymap("n", "<S-k>", function()
	require("smart-splits").move_cursor_left()
end, { desc = "Move to left split" })
keymap("n", "<S-u>", function()
	require("smart-splits").move_cursor_down()
end, { desc = "Move to split below" })
keymap("n", "<S-l>", function()
	require("smart-splits").move_cursor_up()
end, { desc = "Move to split above" })
keymap("n", "<S-h>", function()
	require("smart-splits").move_cursor_right()
end, { desc = "Move to right split" })

keymap("n", "<C-A-S-k>", ":vertical resize -2<CR>", { desc = "Resize split left" })
keymap("n", "<C-A-S-u>", ":resize +2<CR>", { desc = "Resize split down" })
keymap("n", "<C-A-S-l>", ":resize -2<CR>", { desc = "Resize split up" })
keymap("n", "<C-A-S-h>", ":vertical resize +2<CR>", { desc = "Resize split right" })

-- move splits (normal)
keymap("n", "<A-K>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-U>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-L>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-H>", "<C-w>L", { desc = "Move window right" })

-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- split window (normal)
keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>ss", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close window" })

-- tab management (normal)
keymap("n", "<A-h>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<A-k>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<A-w>", "<Cmd>bdelete<CR>", { silent = true })

-- move line (normal + visual)
keymap("n", "<A-l>", ":m .-1<CR>==", { desc = "Move line up" })
keymap("n", "<A-u>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("v", "<A-l>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap("v", "<A-u>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- indent left right (visual)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- paste with no yank (visual)
keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

-- clear highlights (normal)
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })

-- quit (normal)
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

keymap("i", "<D-S-CR>", 'copilot#Accept("")', { expr = true, silent = true, noremap = true, replace_keycodes = true })

vim.keymap.set("i", "<Esc>[13;2u", function()
	if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
		return vim.fn["copilot#Accept"]("")
	else
		return "<CR>"
	end
end, { expr = true, silent = true, noremap = true, replace_keycodes = false, desc = "Accept Copilot with Shift+Enter" })

keymap("i", "<D-S-CR>", function()
	if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
		return vim.fn["copilot#Accept"]("")
	else
		return "<CR>"
	end
end, { expr = true, silent = true, noremap = true, replace_keycodes = false, desc = "Accept Copilot or newline" })

local sc = require("user.smart_cycles")
keymap({ "i", "n" }, "<D-;>", sc.next, { desc = "Smart cycle forward" })
keymap({ "i", "n" }, "<D-S-;>", sc.prev, { desc = "Smart cycle backward" })

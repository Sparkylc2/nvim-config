--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- enter visual block mode with alt-v
keymap("n", "<A-v>", "<C-v>", opts)
-- redo with shift u
keymap("n", "U", "<C-r>", opts)

-- join line below without moving cursor
keymap({ "n", "x" }, "J", "mzJ`z", opts)

-- copy until end of line
keymap({ "n", "x" }, "Y", "y$", opts)

-- paste until end of line
keymap({ "n", "x" }, "P", [[mz"_D"+p`z]], opts)

-- move to bottom of page and end of line
keymap({ "x", "n" }, "G", "G$", opts)
-- move to start of page and start of line
keymap({ "x", "n" }, "gg", "gg^", opts)

-- move half page up/down while keeping cursor centered
keymap("n", "<D-d>", "<C-d>zz", opts)
keymap("n", "<D-u>", "<C-u>zz", opts)

-- search next/prev and center
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- switch ^ and 0 for ease of use
keymap("n", "0", "^", opts)
keymap("n", "^", "0", opts)

-- useless
keymap("n", "Q", "<nop>")

-- quick chmod +x
keymap("n", "<leader>ch", "<cmd>!chmod +x %<CR>", { silent = true })

-- insert mode enhancements
keymap("i", "<C-n>", "<C-o>^", opts)
keymap("i", "<C-o>", "<C-o>$", opts)
keymap("i", "<D-BS>", "<C-u>", opts)

-- move cursor with alt + neio
keymap("i", "<A-i>", "<Up>", opts)
keymap("i", "<A-e>", "<Down>", opts)
keymap("i", "<A-n>", "<Left>", opts)
keymap("i", "<A-o>", "<Right>", opts)

-- win resize commands
keymap("n", "<C-A-n>", ":vertical resize -2<CR>", { desc = "Resize split left" })
keymap("n", "<C-A-e>", ":resize +2<CR>", { desc = "Resize split down" })
keymap("n", "<C-A-i>", ":resize -2<CR>", { desc = "Resize split up" })
keymap("n", "<C-A-o>", ":vertical resize +2<CR>", { desc = "Resize split right" })

-- move splits (normal)
keymap("n", "<A-N>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-E>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-I>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-O>", "<C-w>L", { desc = "Move window right" })

-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- split window (normal)
keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close window" })

-- tab management (normal)
keymap("n", "<A-w>", "<Cmd>bdelete<CR>", { silent = true })

-- move line (normal + visual)
keymap("n", "<A-i>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("n", "<A-e>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("v", "<A-i>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap("v", "<A-e>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- indent left right (visual)
keymap("n", "<A-o>", ">>", { desc = "Indent right" })
keymap("n", "<A-n>", "<<", { desc = "Indent left" })
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- paste with no yank (visual)
keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

-- quit (normal)
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- copilot stuff
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

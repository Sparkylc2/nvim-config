--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap({ "n", "x", "v" }, "n", "h", opts) -- left
keymap({ "n", "x", "v" }, "e", "j", opts) -- down
keymap({ "n", "x", "v" }, "i", "k", opts) -- up
keymap({ "n", "x", "v" }, "o", "l", opts) -- right

keymap("v", "m", "n", { noremap = true, silent = true }) -- next search in visual
keymap("v", "M", "N", { noremap = true, silent = true }) -- prev search in visual
keymap("v", "k", "e", { noremap = true, silent = true }) -- end of word in visual
keymap("v", "K", "E", { noremap = true, silent = true }) -- end of WORD in visual
keymap("v", "h", "n", { noremap = true, silent = true }) -- for consistency

-- make u work like i for motions
keymap("x", "u", "<Nop>", { silent = true })
keymap("o", "u", "<Nop>", { silent = true })

local objs = { "w", "W", "s", "p", "b", "B", '"', "'", "`", ")", "]", "}", ">", "(", "[", "{", "<", "t" }
for _, o in ipairs(objs) do
	vim.keymap.set({ "x", "o" }, "u" .. o, "i" .. o, { noremap = true, silent = true })
end

keymap("o", "k", "e", opts) -- end of word (was e)
keymap("o", "K", "E", opts) -- end of WORD (was E)

keymap("n", "t", "i", opts) -- insert mode
keymap("n", "T", "I", opts) -- insert at beginning of line

keymap({ "n", "x", "o", "v" }, "k", "e", opts) -- end of word
keymap({ "n", "x", "o", "v" }, "K", "E", opts) -- end of WORD

keymap("n", "u", "o", opts) -- open line below
keymap("n", "U", "O", opts) -- open line above

-- undo/redo (normal)
keymap({ "n", "x", "v" }, "j", "u", opts)
keymap({ "n", "x", "v" }, "J", "<C-r>", opts)

-- join with line above
keymap({ "n", "x", "v" }, "H", "mzJ`z", opts)

-- copy until end of line
keymap({ "n", "x", "v" }, "Y", "y$", opts)

-- paste while removing end of line
keymap({ "n", "x", "v" }, "P", [["_d$"+P]], opts)
-- move with middle
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

keymap("n", "m", "nzzzv", opts)
keymap("n", "M", "Nzzzv", opts)

-- useless
keymap("n", "Q", "<nop>")
-- quick chmod +x
keymap("n", "<leader> ch", "<cmd>!chmod +x %<CR>", { silent = true })

keymap("i", "<C-n>", "<C-o>^", opts)
keymap("i", "<C-o>", "<C-o>$", opts)
keymap("i", "<D-BS>", "<C-u>", opts)

keymap("i", "<A-i>", "<Up>", opts)
keymap("i", "<A-e>", "<Down>", opts)
keymap("i", "<A-n>", "<Left>", opts)
keymap("i", "<A-o>", "<Right>", opts)

-- win resize commands
keymap("n", "<C-A-S-n>", ":vertical resize -2<CR>", { desc = "Resize split left" })
keymap("n", "<C-A-S-e>", ":resize +2<CR>", { desc = "Resize split down" })
keymap("n", "<C-A-S-i>", ":resize -2<CR>", { desc = "Resize split up" })
keymap("n", "<C-A-S-o>", ":vertical resize +2<CR>", { desc = "Resize split right" })

-- move splits (normal)
keymap("n", "<A-N>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-E>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-I>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-O>", "<C-w>L", { desc = "Move window right" })

-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- split window (normal)
keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>ss", "<C-w>s", { desc = "Horizontal split" })
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

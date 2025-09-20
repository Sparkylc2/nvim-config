--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Plug>(ColemakNext)", "n", opts)
keymap("n", "<Plug>(ColemakEnd)", "e", opts)
keymap("n", "<Plug>(ColemakInsert)", "i", opts)

keymap("n", "<Plug>(ColemakOpen)", "o", opts)

keymap({ "n", "x", "v" }, "n", "h", opts) -- left
keymap({ "n", "x", "v" }, "e", "j", opts) -- down
keymap({ "n", "x", "v" }, "i", "k", opts) -- up
keymap({ "n", "x", "v" }, "o", "l", opts) -- right

keymap("v", "m", "n", { noremap = true, silent = true }) -- next search in visual
keymap("v", "M", "N", { noremap = true, silent = true }) -- prev search in visual
keymap("v", "k", "e", { noremap = true, silent = true }) -- end of word in visual
keymap("v", "K", "E", { noremap = true, silent = true }) -- end of WORD in visual
keymap("v", "h", "n", { noremap = true, silent = true }) -- for consistency

-- make l work like i for motions
vim.keymap.set("x", "u", "<Nop>", { silent = true })
vim.keymap.set("o", "u", "<Nop>", { silent = true })

local objs = { "w", "W", "s", "p", "b", "B", '"', "'", "`", ")", "]", "}", ">", "(", "[", "{", "<", "t" }
for _, o in ipairs(objs) do
	vim.keymap.set({ "x", "o" }, "u" .. o, "i" .. o, { noremap = true, silent = true })
end

keymap("n", "m", "<Plug>(ColemakNext)", opts) -- next search result
keymap("n", "M", "N", opts) -- previous search result

keymap("n", "u", "<Plug>(ColemakInsert)", opts) -- insert mode
keymap("n", "U", "I", opts) -- insert at beginning of line

keymap({ "n", "x", "o" }, "k", "<Plug>(ColemakEnd)", opts) -- end of word
keymap({ "n", "x", "o" }, "K", "E", opts) -- end of WORD

keymap("n", "l", "<Plug>(ColemakOpen)", opts) -- open line below
keymap("n", "L", "O", opts) -- open line above

keymap("n", "h", "n", opts) -- h becomes next search

-- undo/redo (normal)
keymap("n", "j", "u", opts)
keymap("n", "J", "<C-r>", opts)

-- join with line above
keymap("n", "Y", "mzJ`z", opts)
-- move with middle
keymap("n", "<C-l>", "<C-d>zz", opts)
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

-- move around splits (normal)
-- keymap("n", "<S-n>", function()
-- 	require("smart-splits").move_cursor_left()
-- end, { desc = "Move to left split" })
-- keymap("n", "<S-e>", function()
-- 	require("smart-splits").move_cursor_down()
-- end, { desc = "Move to split below" })
-- keymap("n", "<S-i>", function()
-- 	require("smart-splits").move_cursor_up()
-- end, { desc = "Move to split above" })
-- keymap("n", "<S-o>", function()
-- 	require("smart-splits").move_cursor_right()
-- end, { desc = "Move to right split" })

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

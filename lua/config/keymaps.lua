--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- enter visual block mode with alt-v
keymap("n", "<A-v>", "<C-v>", opts)
-- redo with shift u
keymap("n", "U", "<C-r>", opts)

-- copy until end of line
keymap({ "n", "x" }, "Y", "y$", opts)

-- paste until end of line
keymap({ "n", "x" }, "P", [[mz"_D"+p`z]], opts)

-- move to bottom of page and end of line
keymap({ "x", "n" }, "G", "G$", opts)
-- move to start of page and start of line
keymap({ "x", "n" }, "gg", "gg^", opts)

-- move half page up/down while keeping cursor centered
keymap("n", "<M-U>", "<C-d>zz", opts) -- down
keymap("n", "<M-L>", "<C-u>zz", opts) -- up

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

-- move cursor with alt + neio
keymap("i", "<A-i>", "<Up>", opts)
keymap("i", "<A-e>", "<Down>", opts)
keymap("i", "<A-n>", "<Left>", opts)
keymap("i", "<A-o>", "<Right>", opts)

-- win resize commands
keymap("n", "<C-S-A>", ":vertical resize -2<CR>", { desc = "Resize split left" }) -- n
keymap("n", "<C-S-R>", ":resize +2<CR>", { desc = "Resize split down" }) -- e
keymap("n", "<C-S-S>", ":resize -2<CR>", { desc = "Resize split up" }) -- i
keymap("n", "<C-S-T>", ":vertical resize +2<CR>", { desc = "Resize split right" }) -- o

-- move splits (normal)
keymap("n", "<A-N>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-E>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-I>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-O>", "<C-w>L", { desc = "Move window right" })

-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- tmux's pane mode (M-[) forwards lowercase a/s/r/t here as Alt+Shift, so the
keymap("n", "<C-a>", "<cmd>leftabove vsplit<CR>", { desc = "Split nvim left" })
keymap("n", "<C-s>", "<cmd>belowright split<CR>", { desc = "Split nvim down" })
keymap("n", "<C-r>", "<cmd>aboveleft split<CR>", { desc = "Split nvim up" })
keymap("n", "<C-t>", "<cmd>rightbelow vsplit<CR>", { desc = "Split nvim right" })

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

keymap("n", "<leader>rr", function()
	local t = require("toggleterm.terminal")
	local term = t.get_last_focused() or t.get(1)
	if not term then
		vim.notify("no toggleterm to rerun in", vim.log.levels.WARN)
		return
	end
	term:send("!!\n", false)
end, { desc = "rerun previous terminal command" })

keymap("n", "<M-l>", "<C-o>", { desc = "jumplist back" })
keymap("n", "<M-u>", "<C-i>", { desc = "jumplist forward" })

-- keymap("n", "<C-[>", "<M-[>")
-- keymap("n", "<C-]>", "<M-]>")

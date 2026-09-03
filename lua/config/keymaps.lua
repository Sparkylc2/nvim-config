--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--------- CURSOR NAV ---------
-- move cursor in insert
keymap("i", "<A-i>", "<Up>", opts)
keymap("i", "<A-e>", "<Down>", opts)
keymap("i", "<A-n>", "<Left>", opts)
keymap("i", "<A-o>", "<Right>", opts)
-- enters normal while in insert mode, once an operation has been completed you go right back to normal
keymap("i", "<A-o>", "<C-o>", { desc = "enter normal while in insert and go back to normal?" })
-- move to bottom of page and end of line
keymap({ "x", "n" }, "G", "G$", opts)
-- move to start of page and start of line
keymap({ "x", "n" }, "gg", "gg^", opts)
-- move half page up/down while keeping cursor centered
keymap("n", "<M-U>", "<C-d>zz", opts) -- down
keymap("n", "<M-L>", "<C-u>zz", opts) -- up
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

--------- WINDOW NAV ---------
-- move between nvim splits
keymap("n", "<S-h>", function()
	require("smart-splits").move_cursor_left()
end, { desc = "Move to left split" })
keymap("n", "<S-j>", function()
	require("smart-splits").move_cursor_down()
end, { desc = "Move to split below" })
keymap("n", "<S-k>", function()
	require("smart-splits").move_cursor_up()
end, { desc = "Move to split above" })
keymap("n", "<S-l>", function()
	require("smart-splits").move_cursor_right()
end, { desc = "Move to right split" })
-- move nvim splits
keymap("n", "<A-S-N>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-S-E>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-S-I>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-S-O>", "<C-w>L", { desc = "Move window right" })
-- create nvim splits
keymap("n", "<C-n>", "<cmd>leftabove vsplit<CR>", { desc = "Split nvim left" })
keymap("n", "<C-e>", "<cmd>belowright split<CR>", { desc = "Split nvim down" })
keymap("n", "<C-i>", "<cmd>aboveleft split<CR>", { desc = "Split nvim up" })
keymap("n", "<C-o>", "<cmd>rightbelow vsplit<CR>", { desc = "Split nvim right" })
-- resize nvim splits
keymap("n", "<C-S-n>", function()
	require("smart-splits").resize_left()
end, { desc = "Resize left" })
keymap("n", "<C-S-e>", function()
	require("smart-splits").resize_down()
end, { desc = "Resize down" })
keymap("n", "<C-S-i>", function()
	require("smart-splits").resize_up()
end, { desc = "Resize up" })
keymap("n", "<C-S-o>", function()
	require("smart-splits").resize_right()
end, { desc = "Resize right" })
-- general split commands
keymap("n", "<leader>sx", "<C-w>c", { desc = "Close split" })
keymap("n", "<leader>so", "<C-w>o", { desc = "Close all other splits" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })
local function close_pane_cascade()
	if #vim.api.nvim_tabpage_list_wins(0) > 1 then
		vim.cmd("close")
		return
	end
	if vim.env.TMUX and vim.env.TMUX ~= "" then
		local panes = tonumber(vim.trim(vim.fn.system("tmux display -p '#{window_panes}'")))
		if panes and panes > 1 then
			vim.cmd("silent! wall")
			vim.fn.system("tmux kill-pane")
			return
		end
	end

	vim.cmd("quit")
end
keymap("n", "<M-Q>", close_pane_cascade, { desc = "Close split, then tmux pane" })

--------- MISC QOL ---------
-- enter visual block mode with alt-v
keymap("n", "<A-v>", "<C-v>", opts)
-- redo with shift u
keymap("n", "U", "<C-r>", opts)
-- copy until end of line
keymap({ "n", "x" }, "Y", "y$", opts)
-- paste until end of line
keymap({ "n", "x" }, "P", [[mz"_D"+p`z]], opts)
-- search next/prev and center
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
-- switch ^ and 0 for ease of use
keymap("n", "0", "^", opts)
keymap("n", "^", "0", opts)
-- paste with no yank (visual)
keymap("x", "p", '"_dP', { desc = "Paste without yanking" })
-- useless
keymap("n", "Q", "<nop>")
-- jumplist up and down
keymap("n", "<M-l>", "<C-o>", { desc = "jumplist back" })
keymap("n", "<M-u>", "<C-i>", { desc = "jumplist forward" })
-- quick chmod +x
keymap("n", "<leader>ch", "<cmd>!chmod +x %<CR>", { silent = true })
-- quit (normal)
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })
-- rerun the last shell command
keymap("n", "<leader>rr", function()
	local terms = Snacks.terminal.list()
	local target = terms[#terms]
	if not target or not target:buf_valid() then
		vim.notify("no terminal open to rerun in", vim.log.levels.WARN)
		return
	end
	local chan = vim.bo[target.buf].channel
	if not chan or chan <= 0 then
		vim.notify("terminal has no job channel", vim.log.levels.WARN)
		return
	end
	vim.api.nvim_chan_send(chan, "!!\n")
end, { desc = "rerun previous terminal command" })

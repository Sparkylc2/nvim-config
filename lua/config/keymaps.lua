--leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- undo/redo (normal)
keymap("n", "j", "u", opts)
keymap("n", "J", "<C-r>", opts)

-- move around with ctrl (insert) (start of line, end of line, up down)
keymap("i", "<C-k>", "<C-o>^", opts)
keymap("i", "<C-u>", "<Down>", opts)
keymap("i", "<C-l>", "<Up>", opts)
keymap("i", "<C-h>", "<C-o>$", opts)
keymap("i", "<D-BS>", "<C-u>", opts)

-- move around with alt (insert)
keymap("i", "<A-l>", "<Up>", opts)
keymap("i", "<A-u>", "<Down>", opts)
keymap("i", "<A-k>", "<Left>", opts)
keymap("i", "<A-h>", "<Right>", opts)

-- move around splits (normal)
keymap("n", "<S-k>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<S-u>", "<C-w>j", { desc = "Move to split below" })
keymap("n", "<S-l>", "<C-w>k", { desc = "Move to split above" })
keymap("n", "<S-h>", "<C-w>l", { desc = "Move to right split" })

-- resize splits (normal)
keymap("n", "<C-A-k>", ":vertical resize -2<CR>", { desc = "Resize split left" })
keymap("n", "<C-A-u>", ":resize +2<CR>", { desc = "Resize split down" })
keymap("n", "<C-A-l>", ":resize -2<CR>", { desc = "Resize split up" })
keymap("n", "<C-A-h>", ":vertical resize +2<CR>", { desc = "Resize split right" })

-- move splits (normal)
keymap("n", "<A-K>", "<C-w>H", { desc = "Move window left" })
keymap("n", "<A-U>", "<C-w>J", { desc = "Move window down" })
keymap("n", "<A-L>", "<C-w>K", { desc = "Move window up" })
keymap("n", "<A-H>", "<C-w>L", { desc = "Move window right" })

-- go to previous window (normal)
keymap("n", "<C-\\>", "<C-w>p", { desc = "Go to previous window" })

-- split window (normal)
keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close window" })

-- tab management (normal)
keymap("n", "<A-h>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<A-k>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<A-w>", "<Cmd>bdelete<CR>", { silent = true })

-- move line (normal + visual)
keymap("n", "<A-l>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("n", "<A-u>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("v", "<A-l>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-u>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

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

-- copilot config
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

-- smart cycles config
local sc = require("user.smart_cycles")
keymap({ "i", "n" }, "<D-;>", sc.next, { desc = "Smart cycle forward" })
keymap({ "i", "n" }, "<D-S-;>", sc.prev, { desc = "Smart cycle backward" }) -- Shift-;

vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-chat",
	callback = function()
		local opts = { buffer = true, silent = true }
		vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
		vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", opts)
		vim.keymap.set("n", "<S-k>", "<C-w>h", { desc = "Move to left split" })
		vim.keymap.set("n", "<S-u>", "<C-w>j", { desc = "Move to split below" })
		vim.keymap.set("n", "<S-l>", "<C-w>k", { desc = "Move to split above" })
		vim.keymap.set("n", "<S-h>", "<C-w>l", { desc = "Move to right split" })
	end,
})

-- profiling config
vim.api.nvim_create_user_command("ProfileStart", function()
	require("profile").start("*")
	vim.notify("Profiling started - use :ProfileStop to finish")
end, {})

vim.api.nvim_create_user_command("ProfileStop", function()
	require("profile").stop()
	vim.ui.input({ prompt = "Save profile to (without .json):" }, function(name)
		if name then
			require("profile").export(name .. ".json")
			vim.notify("Profile saved to " .. name .. ".json")
		end
	end)
end, {})
--
-- vim.api.nvim_create_user_command("ProfileStart", function()
-- 	require("plenary.profile").start("nvim-plenary-profile.log", { flame = true })
-- end, {})
--
-- vim.api.nvim_create_user_command("ProfileStop", function()
-- 	require("plenary.profile").stop()
-- 	vim.notify("Saved profile to nvim-plenary-profile.log. Open in speedscope.app")
-- end, {})
--
vim.api.nvim_create_user_command("LazyProfile", function()
	require("lazy").profile()
end, {})

-- luasnip fixes
local keys_to_fix = {
	-- text-object prefixes
	"i",
	"a",
	-- editing operators
	"d",
	"c",
	"s",
	-- visual mode toggles
	"v",
	"V",
	"<C-v>",
	-- paste/repeat/etc.
	"p",
	"P",
	".",
	-- motion keys that can be remapped
	"o",
	"O",
	"x",
	"X",
	-- selection-related
	"r",
	"R",
	"y",
	"Y",
	"u",
	"U",
}

for _, key in ipairs(keys_to_fix) do
	vim.keymap.set("s", key, function()
		vim.api.nvim_feedkeys(key, "n", false)
	end, { silent = true, remap = false, desc = "Don't fuck up in select mode" })
end

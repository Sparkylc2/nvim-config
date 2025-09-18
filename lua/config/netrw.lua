-- === Enable Netrw ===
vim.g.loaded_netrw = nil
vim.g.loaded_netrwPlugin = nil

-- === Netrw Options ===
vim.g.netrw_banner = 0 -- no banner
vim.g.netrw_liststyle = 3 -- tree-style view
vim.g.netrw_winsize = 25 -- window width
vim.g.netrw_keepdir = 0 -- follow dir changes
vim.g.netrw_localcopydircmd = "cp -r"

-- === Show Hidden Files Except .DS_Store ===
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.DS_Store$]]

-- === Toggle netrw with <leader>k (like Neo-tree) ===
local function netrw_toggle()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "netrw" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end
	vim.cmd("Lexplore " .. (vim.g.netrw_winsize or 25))
end

-- === Reveal current file's directory ===
local function netrw_reveal_here()
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.cmd("Lexplore")
	else
		vim.cmd("Lexplore " .. vim.fn.fnameescape(vim.fn.fnamemodify(path, ":h")))
	end
end

-- === Autoclose if netrw is last window (like `close_if_last_window`) ===
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local wins = vim.api.nvim_list_wins()
		if #wins == 1 and vim.bo.filetype == "netrw" then
			vim.cmd("quit")
		end
	end,
})

-- === Keybinds ===
vim.keymap.set("n", "<leader>k", netrw_toggle, { desc = "Toggle netrw explorer" })
vim.keymap.set("n", "<leader>K", netrw_reveal_here, { desc = "Reveal current file in netrw" })

-- === Netrw Buffer Keymaps (match your style) ===
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		local opts = { buffer = true, silent = true }

		-- Open
		vim.keymap.set("n", "<CR>", "<CR>", opts)
		vim.keymap.set("n", "s", "o", opts) -- open in split
		vim.keymap.set("n", "v", "v", opts) -- open in vsplit
		vim.keymap.set("n", "t", "t", opts) -- open in new tab
		vim.keymap.set("n", "P", "p", opts) -- preview

		-- File management
		vim.keymap.set("n", "a", "%", opts) -- new file
		vim.keymap.set("n", "A", "d", opts) -- new directory
		vim.keymap.set("n", "r", "R", opts) -- rename
		vim.keymap.set("n", "d", "D", opts) -- delete
		vim.keymap.set("n", "c", "c", opts) -- copy
		vim.keymap.set("n", "x", "m", opts) -- move

		-- Dotfiles toggle
		vim.keymap.set("n", ".", "gh", opts)

		-- Refresh (sort of)
		vim.keymap.set("n", "R", "<C-l>", opts)

		-- Close
		vim.keymap.set("n", "q", "q", opts)

		-- === Your custom directional movement keys ===
		vim.keymap.set("n", "k", "h", opts) -- go left
		vim.keymap.set("n", "h", "l", opts) -- go right
		vim.keymap.set("n", "l", "k", opts) -- go up
		vim.keymap.set("n", "u", "j", opts) -- go down
	end,
})

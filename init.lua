-- fixes weird OSC-52 clipboard issue
if vim.env.TERM == "xterm-kitty" then
	vim.g.clipboard = {
		name = "pbcopy-pbpaste",
		copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
		paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
		cache_enabled = 0,
	}
end
package.loaded["vim.ui.clipboard.osc52"] = false
-- sets cwd to whatever the input arg was
do
	if vim.fn.argc() > 0 then
		local a0 = vim.fn.fnamemodify(vim.fn.argv(0), ":p") -- absolute path
		if vim.fn.isdirectory(a0) == 1 then
			pcall(vim.loop.chdir, a0)
			vim.cmd("cd " .. vim.fn.fnameescape(a0))
		elseif vim.fn.filereadable(a0) == 1 then
			local dir = vim.fn.fnamemodify(a0, ":h")
			pcall(vim.loop.chdir, dir)
			vim.cmd("cd " .. vim.fn.fnameescape(dir))
		end
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
	})
end

vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
require("user")

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

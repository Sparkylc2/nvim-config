vim.api.nvim_create_user_command("Home", function(opts)
	local target = vim.fn.expand("~/.config/nvim")
	target = vim.fn.fnamemodify(target, ":p") -- absolute path

	pcall(vim.cmd, "silent! AutoSession save")

	pcall(vim.api.nvim_set_current_dir, target)
	pcall(vim.loop.chdir, vim.fn.getcwd())
	vim.cmd("cd " .. vim.fn.fnameescape(target))

	pcall(vim.cmd, "silent! AutoSession restore")
end, {})

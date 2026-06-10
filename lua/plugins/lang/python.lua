vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.keymap.set("n", "<leader>rp", function()
			local file = vim.fn.expand("%:p")
			if file == nil or file == "" then
				vim.notify("No file to run", vim.log.levels.WARN)
				return
			end
			-- Build the command
			local cmd = "python3 " .. vim.fn.shellescape(file)
			-- Use toggleterm's exec with explicit horizontal direction
			require("toggleterm").exec(cmd, 1, 12, nil, "horizontal")
		end, { buffer = true, desc = "Run python file in ToggleTerm" })
	end,
})

vim.api.nvim_create_user_command("JupytextConvert", function()
	local jupytext = vim.fn.expand("~/.virtualenvs/neovim/bin/jupytext")
	local ipynb = vim.fn.expand("%:p")
	local py = vim.fn.expand("%:p:r") .. ".py"
	vim.fn.system({ jupytext, "--to", "py:percent", ipynb })
	vim.cmd.edit(py)
end, {})

return {
	{
		"benlubas/molten-nvim",
		build = ":UpdateRemotePlugins",
		dependencies = { "3rd/image.nvim" },
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = false
			vim.keymap.set("n", "<leader>mi", ":MoltenInit python3<CR>", { desc = "molten init" })
			vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "molten run selection" })
			vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "molten run line" })
			vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { desc = "molten show output" })
			vim.keymap.set("n", "<leader>mc", function()
				local start = vim.fn.search("^# %%", "bnW")
				local end_ = vim.fn.search("^# %%", "nW")
				if start == 0 then
					start = 1
				end
				if end_ == 0 then
					end_ = vim.fn.line("$")
				else
					end_ = end_ - 1
				end
				vim.fn.MoltenEvaluateRange(start, end_)
			end, { desc = "molten run cell" })
		end,
	},
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			max_width = 100,
			max_height = 12,
			integrations = {
				markdown = { enabled = true },
			},
		},
	},
}

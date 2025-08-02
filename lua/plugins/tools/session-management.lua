return {
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			lazy_support = true,
			continue_restore_on_error = true,
			config = function()
				vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
			end,

			post_restore_cmds = {
				function()
					vim.schedule(function()
						vim.cmd("silent! filetype plugin indent on")
						vim.cmd("silent! syntax enable")

						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf) then
								vim.api.nvim_buf_call(buf, function()
									vim.cmd("silent! filetype detect")
									vim.cmd("silent! doautocmd <nomodeline> FileType")
									pcall(function()
										vim.treesitter.start(buf)
									end)
								end)
							end
						end
					end)
				end,
			},
		},
	},
}

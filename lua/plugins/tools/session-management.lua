return {
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			{ "<leader>Ss", "<cmd>AutoSession save<cr>", desc = "Session: save" },
			{ "<leader>Sr", "<cmd>AutoSession restore<cr>", desc = "Session: restore" },
			{ "<leader>Sd", "<cmd>AutoSession deletePicker<cr>", desc = "Session: delete (pick)" },
			{ "<leader>Sf", "<cmd>AutoSession search<cr>", desc = "Session: find" },
			{ "<leader>Sp", "<cmd>AutoSession purgeOrphaned<cr>", desc = "Session: purge orphaned" },
			{ "<leader>St", "<cmd>AutoSession toggle<cr>", desc = "Session: toggle autosave" },
		},
		config = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

			require("auto-session").setup({
				auto_save = true,
				auto_restore = true,
				auto_create = false,

				suppressed_dirs = {
					vim.fn.expand("~"),
					vim.fn.expand("~/Downloads"),
					vim.fn.expand("~/.Trash"),
					"/",
					"/tmp",
				},

				post_restore_cmds = {
					function()
						vim.defer_fn(function()
							for _, b in ipairs(vim.api.nvim_list_bufs()) do
								if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
									return
								end
							end
							local ok, oil = pcall(require, "oil")
							if ok then
								oil.open(vim.fn.getcwd())
							end
						end, 50)
					end,
				},
			})
		end,
	},
}

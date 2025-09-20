return {
	{
		"rmagatti/auto-session",
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>sr", "<cmd>SessionSave<cr>", desc = "Save session" },
			{ "<leader>sl", "<cmd>SessionRestore<cr>", desc = "Restore session" },
			{ "<leader>sd", "<cmd>SessionDelete<cr>", desc = "Delete session" },
			{ "<leader>sf", "<cmd>Telescope session-lens search_session<cr>", desc = "Find sessions" },
		},
		config = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

			require("auto-session").setup({
				auto_session_suppress_dirs = {
					vim.fn.expand("~"),
					vim.fn.expand("~/Downloads"),
					"/",
					"/tmp",
				},
				args_allow_files_auto_save = function()
					local supported = 0

					local buffers = vim.api.nvim_list_bufs()
					for _, buf in ipairs(buffers) do
						if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
							local path = vim.api.nvim_buf_get_name(buf)
							if vim.fn.filereadable(path) ~= 0 then
								supported = supported + 1
							end
						end
					end

					return supported >= 2
				end,
				post_restore_cmds = {
					function()
						vim.defer_fn(function()
							local function has_real_buffers()
								for _, b in ipairs(vim.api.nvim_list_bufs()) do
									if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
										return true
									end
								end
								return false
							end

							if not has_real_buffers() then
								local cwd = vim.fn.getcwd()
								local ok, oil = pcall(require, "oil")
								if ok then
									oil.open(cwd)
								else
									vim.notify("Oil not available to open fallback view", vim.log.levels.ERROR)
								end
							end
						end, 50)
					end,
				},
			})

			local ok, telescope = pcall(require, "telescope")
			if ok then
				pcall(telescope.load_extension, "session-lens")
			end
		end,
	},
}

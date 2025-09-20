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
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,localoptions,tabpages,winpos,winsize,terminal"

			require("auto-session").setup({
				log_level = "error",
				auto_session_enable_last_session = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = true,
				auto_restore_enabled = true,
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "/tmp" },
				auto_session_use_git_branch = false,
				auto_session_create_enabled = true,

				session_lens = {
					load_on_setup = false,
					theme_conf = { border = true },
					previewer = false,
				},

				cwd_change_handling = {
					restore_upcoming_session = false,
					pre_cwd_changed_hook = nil,
					post_cwd_changed_hook = nil,
				},

				pre_save_cmds = {
					function()
						vim.g.oil_disable_autocmds = true

						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local config = vim.api.nvim_win_get_config(win)
							if config.relative ~= "" then
								pcall(vim.api.nvim_win_close, win, false)
							end
						end

						local oil_paths = {}
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
								local name = vim.api.nvim_buf_get_name(buf)
								if name:match("^oil://") then
									table.insert(oil_paths, name:gsub("^oil://", ""))
									pcall(vim.api.nvim_buf_call, buf, function()
										vim.cmd("silent! bwipeout!")
									end)
								end
							end
						end
						if #oil_paths > 0 then
							vim.g.oil_last_paths = oil_paths
						end

						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_valid(buf) then
								local ft = vim.api.nvim_buf_get_option(buf, "filetype")
								local bt = vim.api.nvim_buf_get_option(buf, "buftype")
								local buf_name = vim.api.nvim_buf_get_name(buf)
								if
									vim.tbl_contains({ "neo-tree", "Trouble", "help", "quickfix", "prompt" }, ft)
									or (bt ~= "" and not buf_name:match("^oil://"))
								then
									pcall(vim.api.nvim_buf_delete, buf, { force = true })
								end
							end
						end

						vim.defer_fn(function()
							vim.g.oil_disable_autocmds = false
						end, 100)
					end,
				},

				post_restore_cmds = {
					function()
						local session_cwd = vim.fn.getcwd()
						_G.LOCKED_CWD = session_cwd

						if vim.g.oil_last_paths then
							local paths = vim.g.oil_last_paths
							vim.g.oil_last_paths = nil
							vim.defer_fn(function()
								for _, path in ipairs(paths) do
									pcall(function()
										require("oil").open(path)
									end)
								end
							end, 200)
						end

						vim.defer_fn(function()
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								local buf = vim.api.nvim_win_get_buf(win)
								local bt = vim.api.nvim_buf_get_option(buf, "buftype")
								local name = vim.api.nvim_buf_get_name(buf)
								if bt == "" and name ~= "" then
									vim.api.nvim_set_current_win(win)
									break
								end
							end
						end, 50)
					end,
				},

				bypass_save_filetypes = { "alpha", "dashboard", "oil" },
				close_unsupported_windows = true,
			})

			local ok, telescope = pcall(require, "telescope")
			if ok then
				pcall(telescope.load_extension, "session-lens")
			end
		end,
	},
}

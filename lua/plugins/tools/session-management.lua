return {
	{
		"rmagatti/auto-session",
		-- must load at startup to restore the session for the cwd
		lazy = false,
		-- no telescope dependency: :SessionSearch has its own picker and falls
		-- back to vim.ui.select. The old `dependencies = telescope` was pulling
		-- the whole picker in at startup (~16ms) purely for session-lens.
		keys = {
			-- the Session* commands are deprecated in favour of :AutoSession <sub>
			{ "<leader>Ss", "<cmd>AutoSession save<cr>", desc = "Session: save" },
			{ "<leader>Sr", "<cmd>AutoSession restore<cr>", desc = "Session: restore" },
			{ "<leader>Sd", "<cmd>AutoSession deletePicker<cr>", desc = "Session: delete (pick)" },
			{ "<leader>Sf", "<cmd>AutoSession search<cr>", desc = "Session: find" },
			{ "<leader>Sp", "<cmd>AutoSession purgeOrphaned<cr>", desc = "Session: purge orphaned" },
			{ "<leader>St", "<cmd>AutoSession toggle<cr>", desc = "Session: toggle autosave" },
		},
		config = function()
			-- "terminal" is deliberately absent: restoring terminal buffers
			-- re-spawns jobs (toggleterm, claude) and is the slow, flaky part of
			-- a restore. Everything else here is cheap.
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

			require("auto-session").setup({
				-- explicit save, automatic restore: <leader>Ss writes a session,
				-- entering a directory that already has one restores it. This is
				-- what stops every directory you ever opened accumulating a file.
				auto_save = false,
				auto_restore = true,
				auto_create = false,

				suppressed_dirs = {
					vim.fn.expand("~"),
					vim.fn.expand("~/Downloads"),
					vim.fn.expand("~/.Trash"),
					"/",
					"/tmp",
				},

				-- a restored session with nothing in it lands you on a blank
				-- buffer; open oil at the cwd instead
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

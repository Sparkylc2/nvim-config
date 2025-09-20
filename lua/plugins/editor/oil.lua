return {
	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
	},
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>e",
				function()
					local oil = require("oil")
					-- Open oil in current file's directory or cwd
					local current_file = vim.api.nvim_buf_get_name(0)
					if current_file ~= "" and vim.bo.buftype == "" then
						-- If we're in a real file, open its directory
						oil.open(vim.fn.fnamemodify(current_file, ":h"))
					else
						-- Otherwise just open oil in cwd
						oil.open()
					end
				end,
				desc = "Open Oil file explorer",
			},
			{
				"<leader>E",
				function()
					-- Open oil in project root (cwd)
					require("oil").open(vim.fn.getcwd())
				end,
				desc = "Open Oil at project root",
			},
		},

		opts = {
			default_file_explorer = false,
			skip_confirm_for_simple_edits = true,
			view_options = { show_hidden = true },

			-- THIS IS IMPORTANT: Don't let oil change cwd
			-- Oil should never mess with your working directory
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},

			keymaps = {
				["<leader>e"] = "actions.close",
				["s"] = "actions.select",
				["<leader>rr"] = "actions.refresh",
				["<leader>p"] = "actions.preview",
				[";"] = "actions.parent",
				["<C-s>"] = false, -- Disable any cwd changing keymaps
				["<C-h>"] = false,
				["-"] = false,
			},

			-- Don't change directory when entering oil buffers
			prompt_save_on_select_new_entry = false,

			-- Keep focus on the current window
			restore_win_options = true,
		},

		config = function(_, opts)
			require("oil").setup(opts)

			-- CRITICAL: Disable autochdir completely
			vim.opt.autochdir = false

			-- Lock the CWD to what we started with
			if not _G.LOCKED_CWD then
				_G.LOCKED_CWD = vim.fn.getcwd()
			end

			-- Prevent any directory changes when using Oil
			local oil_group = vim.api.nvim_create_augroup("OilNoCwdChange", { clear = true })

			-- When entering Oil, save current cwd
			vim.api.nvim_create_autocmd("BufEnter", {
				group = oil_group,
				pattern = "oil://*",
				callback = function()
					-- Remember where we are
					if not _G.OIL_SAVED_CWD then
						_G.OIL_SAVED_CWD = vim.fn.getcwd()
					end
				end,
			})

			-- When leaving Oil, restore cwd if it changed
			vim.api.nvim_create_autocmd("BufLeave", {
				group = oil_group,
				pattern = "oil://*",
				callback = function()
					-- Skip if we're in the middle of session operations
					if vim.g.oil_disable_autocmds then
						return
					end
					vim.defer_fn(function()
						if _G.OIL_SAVED_CWD and vim.fn.getcwd() ~= _G.OIL_SAVED_CWD then
							vim.cmd("cd " .. vim.fn.fnameescape(_G.OIL_SAVED_CWD))
						end
						_G.OIL_SAVED_CWD = nil
					end, 10)
				end,
			})

			-- Catch any DirChanged events and revert them if they're from Oil
			vim.api.nvim_create_autocmd("DirChanged", {
				group = oil_group,
				callback = function(args)
					-- If we're in an oil buffer and the dir changed, revert it
					local bufname = vim.api.nvim_buf_get_name(0)
					if bufname:match("^oil://") and _G.LOCKED_CWD then
						if vim.fn.getcwd() ~= _G.LOCKED_CWD then
							vim.schedule(function()
								vim.cmd("cd " .. vim.fn.fnameescape(_G.LOCKED_CWD))
							end)
						end
					end
				end,
			})
		end,
	},
}

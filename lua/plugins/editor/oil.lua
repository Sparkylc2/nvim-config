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
					local current_file = vim.api.nvim_buf_get_name(0)
					local is_real_file = current_file ~= "" and vim.fn.filereadable(current_file) == 1

					if is_real_file then
						oil.open(vim.fn.fnamemodify(current_file, ":h"))
					else
						oil.open(vim.fn.getcwd())
					end
				end,
				desc = "Open Oil file explorer",
			},
			{
				"<leader>E",
				function()
					require("oil").open(vim.fn.getcwd())
				end,
				desc = "Open Oil at project root",
			},
		},

		opts = {
			delete_to_trash = true,
			default_file_explorer = false,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".DS_Store"
				end,
			},

			watch_for_changes = true,

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
				["<C-s>"] = false,
				["<C-h>"] = false,
				["-"] = false,
				["<leader>R"] = "actions.refresh",
			},

			prompt_save_on_select_new_entry = false,

			restore_win_options = true,
		},

		config = function(_, opts)
			require("oil").setup(opts)

			local function save_session_in_oil_dir()
				local oil = require("oil")
				local dir = oil.get_current_dir()
				if not dir then
					vim.notify("Oil: no directory?", vim.log.levels.WARN)
					return
				end
				local old = vim.fn.getcwd()
				vim.cmd("lcd " .. vim.fn.fnameescape(dir))
				local ok, autosession = pcall(require, "auto-session")
				if ok and autosession.SaveSession then
					autosession.SaveSession()
				else
					vim.cmd("SessionSave")
				end
				vim.cmd("lcd " .. vim.fn.fnameescape(old))
				vim.notify("Session saved for " .. dir)
			end

			local function load_session_in_oil_dir()
				local oil = require("oil")
				local dir = oil.get_current_dir()
				if not dir then
					vim.notify("Oil: no directory?", vim.log.levels.WARN)
					return
				end
				local old = vim.fn.getcwd()
				vim.cmd("cd" .. vim.fn.fnameescape(dir))
				local ok, autosession = pcall(require, "auto-session")
				if ok and autosession.RestoreSession then
					autosession.RestoreSession()
				else
					vim.cmd("SessionRestore")
				end
				-- vim.cmd("lcd " .. vim.fn.fnameescape(old))
				vim.notify("Session loaded for " .. dir)
			end

			-- save session in current oil dir
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "oil",
				callback = function(ev)
					vim.keymap.set("n", "<leader>ss", save_session_in_oil_dir, {
						buffer = ev.buf,
						desc = "Save AutoSession for this Oil directory",
						silent = true,
					})
					vim.keymap.set("n", "<leader>sl", load_session_in_oil_dir, {
						buffer = ev.buf,
						desc = "Load AutoSession for this Oil directory",
						silent = true,
					})
				end,
			})
		end,
	},
}

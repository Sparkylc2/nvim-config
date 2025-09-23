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
				custom_filter = function(name, _entry)
					return name ~= ".DS_Store"
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
		end,
	},
}

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>k", "<cmd>Neotree toggle <cr>", desc = "Toggle file explorer" },
		},
		opts = {
			filesystem = {
				bind_to_cwd = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_by_name = {
						".DS_Store",
					},
				},
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			window = {
				position = "current",
				mappings = {
					j = "none",
					k = "none",
					h = "none",
					l = "none",
					K = "none",
					U = "none",
					H = "none",
					L = "none",
					["<S-BS>"] = "set_root",
				},
			},
			open_files_do_not_replace_types = { "neo-tree", "Trouble", "qf" },
			close_if_last_window = true,
			hijack_netrw_behavior = "open_default",
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
	},
}

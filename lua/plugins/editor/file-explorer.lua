return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
			{ "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
		},
		opts = {
			filesystem = {
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
		},
	},
}

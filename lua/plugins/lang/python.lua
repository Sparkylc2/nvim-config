return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		ft = "python",
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
		},
		config = true,
	},
}

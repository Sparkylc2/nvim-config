return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>rs",
				function()
					require("telescope").extensions.refactoring.refactors()
				end,
				mode = { "n", "x" },
				desc = "Refactor",
			},
		},

		config = true,
	},
}


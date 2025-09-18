return {
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("ts-comments").setup(opts)
		end,
	},
}

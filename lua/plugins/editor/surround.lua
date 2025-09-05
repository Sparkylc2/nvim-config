return {
	{
		"kylechui/nvim-surround",
		version = "*",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
}

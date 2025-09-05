return {
	{
		"nathom/filetype.nvim",
		config = function()
			require("filetype").setup({
				overrides = {
					extensions = {
						tex = "tex",
						vue = "vue",
						md = "markdown",
					},
				},
			})
		end,
	},
}

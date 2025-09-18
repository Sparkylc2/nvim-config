return {
	{
		"nathom/filetype.nvim",

		enabled = false,
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

return {
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		ft = "json",

		event = "VeryLazy",
		config = function()
			require("package-info").setup({
				hide_up_to_date = true,
			})
		end,
	},
}

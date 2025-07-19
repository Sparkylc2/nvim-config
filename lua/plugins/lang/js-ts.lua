return {
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		ft = "json",
		config = function()
			require("package-info").setup({
				colors = {
					up_to_date = "#3C4048",
					outdated = "#d19a66",
				},
				hide_up_to_date = true,
			})
		end,
	},
}

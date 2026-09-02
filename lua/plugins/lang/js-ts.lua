return {
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		-- lazy ORs its triggers, so the old `event = "VeryLazy"` alongside this
		-- meant it loaded every session and the ft gate did nothing
		ft = { "json" },
		config = function()
			require("package-info").setup({
				hide_up_to_date = true,
			})
		end,
	},
}

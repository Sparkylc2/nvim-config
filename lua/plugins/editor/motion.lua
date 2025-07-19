return {
	{
		"phaazon/hop.nvim",
		branch = "v2",
		keys = {
			{ "s", "<cmd>HopWord<cr>", desc = "Hop to word", mode = { "n", "v" } },
			{ "S", "<cmd>HopLine<cr>", desc = "Hop to line", mode = { "n", "v" } },
		},
		config = true,
	},
}

return {
	"tris203/precognition.nvim",
	event = "VeryLazy",

	opts = {
		startVisible = true,
		showBlankVirtLine = false,
		highlightColor = { link = "Added" },
		hints = {
			w = { text = "w", prio = 10 },
			b = { text = "b", prio = 9 },
			e = { text = "k", prio = 8 },
			W = { text = "W", prio = 7 },
			B = { text = "B", prio = 6 },
			E = { text = "K", prio = 5 },
		},
	},
}

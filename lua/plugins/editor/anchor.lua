return {
	"sparkylc2/anchor.nvim",
	dependencies = { "stevearc/oil.nvim" },
	main = "anchor",
	opts = {
		keys = {
			add = "<leader>a",
			menu = "<leader>m",
			nav_prefix = "<leader>",
		},
		max_slots = 9,
	},
}

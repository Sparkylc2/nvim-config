return {
	dir = "/Users/lukascampbell/Documents/GitHub/anchor.nvim", -- or push to GitHub and use the URL
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

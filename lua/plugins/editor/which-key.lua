return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
		},
		opts = {
			delay = 500,
			plugins = { spelling = true },
			keys = {
				scroll_up = "<Up>",
				scroll_down = "<Down>",
			},
			spec = {
				{ "<leader>m", group = "Multicursor" },
			},
		},
	},
}

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
				{ "<leader>c", group = "Claude" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>j", group = "Jupyter" },
				{ "<leader>l", group = "LSP / Format / Tex" },
				{ "<leader>m", group = "Multicursor" },

				{ "<leader>r", group = "Refactor" },

				{ "<leader>s", group = "Split / Swap" },
				{ "<leader>S", group = "Session" },

				{ "<leader>t", group = "Trouble / Terminal" },
				{ "<leader>tc", group = "Terminal (buffer cwd)" },

				{ "<leader>u", group = "Toggle" },
				{ "<leader>x", group = "Todo / Lists" },
			},
		},
	},
}

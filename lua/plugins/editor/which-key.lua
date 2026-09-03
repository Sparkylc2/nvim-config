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
			-- Group names derived from what each prefix actually contains.
			-- Two prefixes hold two unrelated things -- noted below.
			spec = {
				{ "<leader>c", group = "Claude" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>l", group = "LSP / Format" },
				{ "<leader>m", group = "Multicursor" },

				-- refactoring.nvim extractions, plus <leader>rr which reruns the
				-- last terminal command and does not belong here
				{ "<leader>r", group = "Refactor" },

				-- Splits, plus vimtex's <leader>sp (Sync to PDF), plus the
				-- treesitter swap textobjects (sa/sf/sL), which are buffer-local
				-- so they do not show in a global keymap dump
				{ "<leader>s", group = "Split / Swap" },
				{ "<leader>S", group = "Session" },

				-- DOUBLE-BOOKED: Trouble (tt/tT/ts/tS/tL/tQ) and Terminal
				-- (tf/th/tv/tcf/tch/tcv) share this prefix
				{ "<leader>t", group = "Trouble / Terminal" },
				{ "<leader>tc", group = "Terminal (buffer cwd)" },

				{ "<leader>u", group = "Toggle" },
				{ "<leader>x", group = "Todo / Lists" },
			},
		},
	},
}

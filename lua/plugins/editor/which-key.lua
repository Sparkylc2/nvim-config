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
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		opts = {
			delay = 100,
			filter = function(mapping)
				local lhs = mapping.lhs
				if not lhs then
					return true
				end
				for i = 1, #lhs do
					if lhs:byte(i) > 126 or lhs:byte(i) < 32 then
						return false
					end
				end
				return true
			end,
			plugins = { spelling = true },
			spec = {
				-- Leader groups
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>s", group = "search/split" },
				{ "<leader>t", group = "toggle/terminal" },
				{ "<leader>u", group = "ui" },
				{ "<leader>w", group = "windows" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },

				-- COLEMAK OPERATOR-PENDING MODE SPECS
				-- Movement keys in operator mode
				{ "n", desc = "Left", mode = "o" },
				{ "e", desc = "Down", mode = "o" },
				{ "i", desc = "Up", mode = "o" },
				{ "o", desc = "Right", mode = "o" },
				{ "k", desc = "End of word", mode = "o" },
				{ "K", desc = "End of WORD", mode = "o" },

				-- Hide default 'i' in operator mode
				{ "i", hidden = true, mode = "o" },

				-- 'u' as inside operator
				{ "u", group = "inside", mode = "o" },
				{ "uw", desc = "inside word", mode = "o" },
				{ "uW", desc = "inside WORD", mode = "o" },
				{ "us", desc = "inside sentence", mode = "o" },
				{ "up", desc = "inside paragraph", mode = "o" },
				{ "ub", desc = "inside block", mode = "o" },
				{ "uB", desc = "inside BLOCK", mode = "o" },
				{ 'u"', desc = "inside double quotes", mode = "o" },
				{ "u'", desc = "inside single quotes", mode = "o" },
				{ "u`", desc = "inside backticks", mode = "o" },
				{ "u)", desc = "inside parentheses", mode = "o" },
				{ "u]", desc = "inside brackets", mode = "o" },
				{ "u}", desc = "inside braces", mode = "o" },
				{ "u>", desc = "inside angle brackets", mode = "o" },
				{ "u(", desc = "inside parentheses", mode = "o" },
				{ "u[", desc = "inside brackets", mode = "o" },
				{ "u{", desc = "inside braces", mode = "o" },
				{ "u<", desc = "inside angle brackets", mode = "o" },
				{ "ut", desc = "inside tag", mode = "o" },

				{ "k", desc = "End of word", mode = "x" },
				{ "K", desc = "End of WORD", mode = "x" },

				-- 'u' as inside in visual mode
				{ "u", group = "inside", mode = "x" },
				{ "uw", desc = "inside word", mode = "x" },
				{ "uW", desc = "inside WORD", mode = "x" },
				{ "us", desc = "inside sentence", mode = "x" },
				{ "up", desc = "inside paragraph", mode = "x" },
				{ "ub", desc = "inside block", mode = "x" },
				{ "uB", desc = "inside BLOCK", mode = "x" },
				{ 'u"', desc = "inside double quotes", mode = "x" },
				{ "u'", desc = "inside single quotes", mode = "x" },
				{ "u`", desc = "inside backticks", mode = "x" },
				{ "u)", desc = "inside parentheses", mode = "x" },
				{ "u]", desc = "inside brackets", mode = "x" },
				{ "u}", desc = "inside braces", mode = "x" },
				{ "u>", desc = "inside angle brackets", mode = "x" },
				{ "u(", desc = "inside parentheses", mode = "x" },
				{ "u[", desc = "inside brackets", mode = "x" },
				{ "u{", desc = "inside braces", mode = "x" },
				{ "u<", desc = "inside angle brackets", mode = "x" },
				{ "ut", desc = "inside tag", mode = "x" },

				-- Operator descriptions in normal mode
				{ "cn", desc = "change left" },
				{ "ce", desc = "change down" },
				{ "ci", desc = "change up" },
				{ "co", desc = "change right" },
				{ "ck", desc = "change to end of word" },
				{ "cK", desc = "change to end of WORD" },

				{ "dn", desc = "delete left" },
				{ "de", desc = "delete down" },
				{ "di", desc = "delete up" },
				{ "do", desc = "delete right" },
				{ "dk", desc = "delete to end of word" },
				{ "dK", desc = "delete to end of WORD" },

				{ "yn", desc = "yank left" },
				{ "ye", desc = "yank down" },
				{ "yi", desc = "yank up" },
				{ "yo", desc = "yank right" },
				{ "yk", desc = "yank to end of word" },
				{ "yK", desc = "yank to end of WORD" },

				{ "vn", desc = "visual left" },
				{ "ve", desc = "visual down" },
				{ "vi", desc = "visual up" },
				{ "vo", desc = "visual right" },
				{ "vk", desc = "visual to end of word" },
				{ "vK", desc = "visual to end of WORD" },

				{ "=n", desc = "indent left" },
				{ "=e", desc = "indent down" },
				{ "=i", desc = "indent up" },
				{ "=o", desc = "indent right" },
				{ "=k", desc = "indent to end of word" },
				{ "=K", desc = "indent to end of WORD" },

				{ ">n", desc = "shift right left" },
				{ ">e", desc = "shift right down" },
				{ ">i", desc = "shift right up" },
				{ ">o", desc = "shift right right" },
				{ ">k", desc = "shift right to end of word" },
				{ ">K", desc = "shift right to end of WORD" },

				{ "<n", desc = "shift left left" },
				{ "<e", desc = "shift left down" },
				{ "<i", desc = "shift left up" },
				{ "<o", desc = "shift left right" },
				{ "<k", desc = "shift left to end of word" },
				{ "<K", desc = "shift left to end of WORD" },

				{ "gn", desc = "go left" },
				{ "ge", desc = "go down" },
				{ "gi", desc = "go up" },
				{ "go", desc = "go right" },
			},
		},
	},
}

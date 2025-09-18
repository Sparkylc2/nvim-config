return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },

			spec = {
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
			},
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
		},
		config = function()
			require("which-key").setup({
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
			})
		end,
	},
}

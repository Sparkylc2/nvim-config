return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
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
		},
		config = function()
			require("which-key").setup({
				filter = function(mapping)
					if mapping.lhs then
						return mapping.lhs:match("^[\32-\126]*$") ~= nil
					end
					return true
				end,
			})
		end,
	},
}

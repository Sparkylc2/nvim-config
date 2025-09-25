return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },

		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "isort" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				tex = { "latexindent" },
				plaintex = { "latexindent" },
				bib = { "bibtex-tidy" },
			},
			format_on_save = {
				lsp_fallback = true,
			},
		},
	},
}

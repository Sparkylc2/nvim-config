return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },

		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
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
				-- ruff replaces black + isort: one tool, and "isort" was listed
				-- here but never installed, so import sorting never ran
				python = { "ruff_organize_imports", "ruff_format" },
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
				markdown = { "injected" },
				quarto = { "injected" },
			},
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype
				if ft == "markdown" or ft == "quarto" then
					return nil
				end
				return { lsp_fallback = true }
			end,
		},
	},
}

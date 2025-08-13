return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
				-- javascript = { "eslint" },
				-- typescript = { "eslint" },
				-- javascriptreact = { "eslint" },
				-- typescriptreact = { "eslint" },
				-- vue = { "eslint_d" },
				-- tex = { "chktex" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}

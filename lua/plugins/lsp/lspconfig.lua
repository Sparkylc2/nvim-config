return {
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile", "VeryLazy" },

		config = function()
			vim.opt.signcolumn = "yes"

			-- local lspconfig = require("lspconfig")
			-- lspconfig.ltex.setup({
			-- 	filetypes = { "tex", "plaintex", "bib", "markdown" },
			-- 	settings = {
			-- 		ltex = {
			-- 			enabled = { "latex", "tex", "bibtex", "markdown" },
			-- 			language = "en-GB",
			-- 			checkFrequency = "edit",
			-- 			diagnosticSeverity = "warning",
			-- 		},
			-- 	},
			-- 	on_attach = function(client, bufnr)
			-- 		vim.notify("LTeX attached and enabled for buffer " .. bufnr)
			-- 	end,
			-- })
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
					end

					map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
					map("n", "gr", vim.lsp.buf.references, "Find References")
					map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
					map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
					map("n", "go", vim.lsp.buf.type_definition, "Go to Type Definition")
					map("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code Action")
					map("n", "<leader>ld", vim.diagnostic.open_float, "Show Diagnostic")
					map("n", "[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
				end,
			})
		end,
	},
}

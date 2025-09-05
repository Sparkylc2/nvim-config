return {
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile", "VeryLazy" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			vim.opt.signcolumn = "yes"

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf, remap = false }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature Help" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
					vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
					vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Diagnostic" })
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Previous Diagnostic" })
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
				end,
			})
		end,
	},
}

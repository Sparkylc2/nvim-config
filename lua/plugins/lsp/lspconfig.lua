return {
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			vim.opt.signcolumn = "yes"

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf, remap = false }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})

			-- lsp_zero.on_attach(function(client, bufnr)
			-- 	local opts = { buffer = bufnr, remap = false }
			-- 	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			-- 	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			-- 	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			-- 	vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
			-- 	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			-- 	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
			-- 	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			-- 	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
			-- 	vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			-- 	vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
			-- 	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			-- 	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			-- end)

			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},
}

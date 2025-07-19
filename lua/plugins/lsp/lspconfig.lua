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
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				-- Keymaps
				local opts = { buffer = bufnr, remap = false }
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
			end)

			-- Configure language servers
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"lua_ls",
					"clangd", -- C/C++
					"pyright", -- Python
					"ts_ls", -- TypeScript/JavaScript
					"vue_ls", -- Vue
					"html", -- HTML
					"cssls", -- CSS
					"jsonls", -- JSON
					"yamlls", -- YAML
					"texlab", -- LaTeX
				},
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							settings = {
								Lua = {
									runtime = { version = "LuaJIT" },
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										library = {
											vim.api.nvim_get_runtime_file("", true),
											vim.env.VIMRUNTIME,
											vim.fn.stdpath("config"),
										},
										checkThirdParty = false,
									},
									telemetry = { enable = false },
								},
							},
						})
					end,
					clangd = function()
						require("lspconfig").clangd.setup({
							cmd = {
								"clangd",
								"--offset-encoding=utf-16",
								"--background-index",
								"--clang-tidy",
								"--header-insertion=iwyu",
								"--completion-style=detailed",
								"--function-arg-placeholders",
							},
						})
					end,
					pyright = function()
						require("lspconfig").pyright.setup({
							settings = {
								python = {
									analysis = {
										typeCheckingMode = "strict",
										autoSearchPaths = true,
										useLibraryCodeForTypes = true,
									},
								},
							},
						})
					end,
					volar = function()
						require("lspconfig").volar.setup({
							filetypes = {
								"typescript",
								"javascript",
								"javascriptreact",
								"typescriptreact",
								"vue",
								"json",
							},
						})
					end,
					texlab = function()
						require("lspconfig").texlab.setup({
							settings = {
								texlab = {
									build = {
										onSave = true,
										executable = "latexmk",
										args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
									},
									chktex = {
										onOpenAndSave = true,
										onEdit = false,
									},
									forwardSearch = {
										executable = "skim",
										args = { "%l", "%p", "%f" },
									},
								},
							},
						})
					end,
				},
			})
		end,
	},
}

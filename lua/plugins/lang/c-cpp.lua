return {
	{
		"neovim/nvim-lspconfig",
		ft = { "c", "cpp", "cxx", "cc" },
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			lspconfig.clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--std=c++20",
					"--limit-results=50",
					"--compile-commands-dir=.",
					"--pch-storage=memory",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = false,
					clangdFileStatus = true,
				},
				capabilities = capabilities,
				settings = {
					clangd = {

						InlayHints = {
							Designators = false,
							Enabled = false,
							ParameterNames = false,
							DeducedTypes = false,
						},
						SemanticHighlighting = false,
					},
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.semanticTokensProvider = nil

					if client.server_capabilities.signatureHelpProvider then
						client.server_capabilities.signatureHelpProvider.triggerCharacters = { "(", "," }
					end

					vim.bo[bufnr].updatetime = 400

					local line_count = vim.api.nvim_buf_line_count(bufnr)
					if line_count > 1000 then
						client.server_capabilities.documentHighlightProvider = nil
						vim.bo[bufnr].updatetime = 800
					end
				end,
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern(
						"Makefile",
						"configure.ac",
						"configure.in",
						"config.h.in",
						"meson.build",
						"meson_options.txt",
						"build.ninja",
						"compile_commands.json",
						"compile_flags.txt",
						".git"
					)(fname)
				end,
			})
		end,
	},
}

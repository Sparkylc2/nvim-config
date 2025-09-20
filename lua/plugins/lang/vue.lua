return {

	{
		"catgoose/vue-goto-definition.nvim",
		ft = "vue",
		event = "VeryLazy",

		enabled = false,
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		ft = { "vue", "typescript", "javascript" },
		config = function()
			local old_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if type(msg) == "string" and msg:find("`require%('lspconfig'%)`%s*\"framework\"%s*is%s*deprecated") then
					return -- swallow just this warning
				end
				return old_notify(msg, level, opts)
			end
			local lspconfig = require("lspconfig")

			local vue_language_server_path =
				"/Users/lukascampbell/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server"

			local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}

			lspconfig.ts_ls.setup({
				init_options = {
					plugins = {
						vue_plugin,
					},
				},
				filetypes = tsserver_filetypes,
			})

			lspconfig.volar.setup({})
			vim.notify = old_notify
		end,
	},
}

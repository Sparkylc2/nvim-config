return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"lua_ls",
					"clangd",
					"texlab",
					"ts_ls",
					"vue_ls",
					"cssls",
					"tailwindcss",
					"html",
				},
				automatic_enable = false,
			})
		end,
	},
}

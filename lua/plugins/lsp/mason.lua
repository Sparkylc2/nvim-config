-- mason v2. The williamboman/* repos were renamed to mason-org/*; GitHub
-- redirects, so lazy has been pulling v2 code under the old name -- which works
-- but hides which version you are actually on.
--
-- NOTE: neither spec is lazy-triggered on purpose. mason.setup() is what
-- prepends ~/.local/share/nvim/mason/bin to PATH, and without it nvim cannot
-- find clangd, pyright and friends. Deferring these breaks LSP for any file
-- opened before the trigger fires.

return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = require("config.servers"),
			-- servers are enabled explicitly in config/lsp.lua, next to their
			-- settings; letting mason enable them too would configure them twice
			automatic_enable = false,
		},
	},
}

-- nvim-lspconfig is kept purely as a data provider: it ships lsp/<server>.lua
-- files that vim.lsp.config() reads for cmd, filetypes and root_markers. It is
-- never require()d -- the require("lspconfig") framework is deprecated on 0.11.
--
-- All server configuration and the LspAttach keymaps live in lua/config/lsp.lua.
-- It must load before any client attaches, hence BufReadPre/BufNewFile.

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
	},
}

-- Single source of truth for LSP servers.
--
-- config/lsp.lua passes this to vim.lsp.enable(); plugins/lsp/mason.lua passes
-- the same list to mason-lspconfig's ensure_installed. Previously those were two
-- hand-maintained lists that disagreed: ltex, matlab_ls and glsl_analyzer were
-- enabled but never ensured, and two markdown servers were installed but unused.
--
-- Names are lspconfig server names. mason-lspconfig maps them to package names
-- (lua_ls -> lua-language-server, cssls -> css-lsp, and so on).

return {
	"clangd",
	"cssls",
	"eslint", -- project-config-aware JS/TS linting, reads your .eslintrc
	"glsl_analyzer",
	"html",
	"lua_ls",
	"pyright", -- types only; ruff owns linting and formatting
	"ruff",
	"tailwindcss",
	"texlab",
	"ts_ls",
	"vue_ls",
}

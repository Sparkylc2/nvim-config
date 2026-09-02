-- names are lspconfig server names. mason-lspconfig maps them to package names
-- (lua_ls -> lua-language-server, cssls -> css-lsp, and so on).

return {
	"clangd",
	"cssls",
	"eslint", -- project-config-aware JS/TS linting, reads your .eslintrc
	"glsl_analyzer",
	"html",
	"lua_ls",
	"ltex", -- prose grammar/style; markdown + tex only, see config/lsp.lua
	"basedpyright",
	"ruff",
	"tailwindcss",
	"texlab",
	"vtsls", -- one TS server; ts_ls dropped
	"vue_ls",
}

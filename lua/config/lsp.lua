vim.lsp.config("texlab", {
	settings = {
		texlab = {
			rootDirectory = nil,
			build = {
				executable = "latexmk",
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
				onSave = false,
				forwardSearchAfter = false,
			},
			forwardSearch = {
				executable = nil,
				args = {},
			},
			chktex = {
				onOpenAndSave = false,
				onEdit = false,
			},
			diagnosticsDelay = 300,
			latexFormatter = "latexindent",
			latexindent = {
				["local"] = nil,
				modifyLineBreaks = false,
			},
		},
	},
})
vim.lsp.config("ltex", {
	filetypes = { "markdown", "tex", "latex", "text" },
	settings = {
		ltex = {
			language = "en-GB",
		},
	},
})

vim.lsp.enable({
	"vue_ls",
	"ts_ls",
	"lua_ls",
	"ltex",
	"cssls",
	"tailwindcss",
	"html",
	"clangd",
	"pyright",
	"texlab",
})

-- Signature help
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })

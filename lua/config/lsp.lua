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

vim.lsp.config("pyright", {
	settings = {
		python = {
			-- pythonPath = vim.g.python3_host_prog,
		},
	},
})

vim.lsp.config("matlab_ls", {
	settings = {
		MATLAB = {
			installPath = "/Applications/MATLAB_R2024b.app",
			matlabConnectionTiming = "onStart",
			telemetry = true,
		},
	},
})

local vue_language_server_path =
	"/Users/lukascampbell/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server"

local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

vim.lsp.config("ts_ls", {
	init_options = {
		plugins = {
			vue_plugin,
		},
	},
	filetypes = tsserver_filetypes,
})

vim.lsp.config("volar", {})
vim.lsp.config("eslint", { enable = false })
vim.lsp.enable({
	"vue_ls",
	"ts_ls",
	"lua_ls",
	"ltex",
	"cssls",
	"tailwindcss",
	"html",
	"matlab_ls",
	"clangd",
	"pyright",
	"texlab",
})

-- Signature help
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.set_log_level("DEBUG")

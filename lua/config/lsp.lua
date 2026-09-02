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

local function venv_python(root)
	for _, name in ipairs({ ".venv", "venv", ".env" }) do
		local exe = root .. "/" .. name .. "/bin/python"
		if vim.uv.fs_stat(exe) then
			return exe
		end
	end
	return vim.fn.exepath("python3")
end

vim.lsp.config("pyright", {
	before_init = function(params, config)
		local root = config.root_dir or params.rootPath or vim.fn.getcwd()
		config.settings.python.pythonPath = venv_python(root)
	end,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
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

vim.lsp.config("eslint", { enable = false })

vim.filetype.add({
	extension = {
		fs = "glsl",
		vs = "glsl",
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
	"matlab_ls",
	"clangd",
	"pyright",
	"texlab",
	"glsl_analyzer",
})

-- Signature help
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.set_log_level("WARN")

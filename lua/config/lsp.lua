local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
	capabilities = capabilities,
})

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
				onOpenAndSave = true,
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
	filetypes = { "markdown", "tex", "latex" },
	settings = {
		ltex = {
			language = "en-GB",
		},
	},
})

vim.api.nvim_create_user_command("LtexStart", function()
	vim.lsp.enable("ltex")
	local cfg = vim.lsp.config["ltex"]
	if cfg then
		vim.lsp.start(cfg, { bufnr = 0 })
	end
end, { desc = "Start ltex grammar checking for this buffer" })

-- find the interpreter pyright should use
local function venv_python(root)
	-- activated environment always wins
	if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
		local exe = vim.env.VIRTUAL_ENV .. "/bin/python"
		if vim.uv.fs_stat(exe) then
			return exe
		end
	end

	-- 2. conda
	if vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX ~= "" then
		local exe = vim.env.CONDA_PREFIX .. "/bin/python"
		if vim.uv.fs_stat(exe) then
			return exe
		end
	end

	-- in-tree virtualenvs
	for _, name in ipairs({ ".venv", "venv", ".env" }) do
		local exe = root .. "/" .. name .. "/bin/python"
		if vim.uv.fs_stat(exe) then
			return exe
		end
	end

	-- poetry
	if vim.uv.fs_stat(root .. "/poetry.lock") and vim.fn.executable("poetry") == 1 then
		local out = vim.fn.system({ "poetry", "env", "info", "-e" })
		if vim.v.shell_error == 0 then
			local exe = vim.trim(out)
			if exe ~= "" and vim.uv.fs_stat(exe) then
				return exe
			end
		end
	end

	return vim.fn.exepath("python3")
end

vim.lsp.config("basedpyright", {
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	before_init = function(params, config)
		local function str(v)
			return (type(v) == "string" and v ~= "") and v or nil
		end
		local root = str(config.root_dir) or str(params.rootPath) or vim.fn.getcwd()
		local exe = venv_python(root)
		config.settings.basedpyright.pythonPath = exe

		local out =
			vim.fn.system({ exe, "-c", "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" })
		if vim.v.shell_error == 0 then
			local ver = vim.trim(out)
			if ver:match("^%d+%.%d+$") then
				config.settings.basedpyright.analysis.pythonVersion = ver
			end
		end
	end,
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",

				typeCheckingMode = "standard",

				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
				},

				diagnosticSeverityOverrides = {
					reportUnknownMemberType = "none",
					reportUnknownVariableType = "none",
					reportUnknownArgumentType = "none",
					reportUnknownParameterType = "none",
					reportMissingParameterType = "none",
					reportUnknownLambdaType = "none",
					reportImplicitStringConcatenation = "none",
					reportAny = "none",
					reportExplicitAny = "none",
					reportIgnoreCommentWithoutRule = "none",
				},
			},
		},
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
		"--limit-results=50",
		"--compile-commands-dir=.",
		"--pch-storage=memory",
	},
	root_markers = {
		"compile_commands.json",
		"compile_flags.txt",
		"Makefile",
		"configure.ac",
		"configure.in",
		"config.h.in",
		"meson.build",
		"meson_options.txt",
		"build.ninja",
		".git",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = false,
		clangdFileStatus = true,
	},
	settings = {
		clangd = {
			InlayHints = {
				Designators = true,
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
			SemanticHighlighting = false,
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.semanticTokensProvider = nil
		if client.server_capabilities.signatureHelpProvider then
			client.server_capabilities.signatureHelpProvider.triggerCharacters = { "(", "," }
		end
		if vim.api.nvim_buf_line_count(bufnr) > 1000 then
			client.server_capabilities.documentHighlightProvider = nil
		end
	end,
})

vim.lsp.config("ruff", {
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
})

vim.lsp.config("eslint", {
	settings = {
		workingDirectories = { mode = "auto" },
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

vim.lsp.config("vtsls", {
	filetypes = tsserver_filetypes,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = { vue_plugin },
			},
		},
	},
})

vim.filetype.add({
	extension = {
		fs = "glsl",
		vs = "glsl",
	},
})

vim.lsp.enable(require("config.servers"))

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
	desc = "LSP actions",
	callback = function(event)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end

		map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "gr", vim.lsp.buf.references, "Find References")
		map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
		map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
		map("n", "go", vim.lsp.buf.type_definition, "Go to Type Definition")
		map("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
		map("n", "gK", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
		map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>ld", vim.diagnostic.open_float, "Show Diagnostic")
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous Diagnostic")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next Diagnostic")
	end,
})

vim.lsp.log.set_level(vim.log.levels.WARN)

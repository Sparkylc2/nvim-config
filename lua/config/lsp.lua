-- nvim 0.11 LSP wiring.
--
-- Servers are described with vim.lsp.config() and turned on with
-- vim.lsp.enable(). nvim-lspconfig is present only as a *data provider* -- it
-- ships lsp/<server>.lua files that supply cmd/filetypes/root_markers -- and is
-- never require()d. That framework is deprecated on 0.11.

-- Defaults merged into every server. Nothing was advertising cmp's completion
-- capabilities before this, so servers saw only nvim's built-in set and LSP
-- snippet expansion never worked properly.
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
			-- chktex IS the LaTeX linter. Both were false, so tex had no
			-- linting at all. onEdit stays off: it relints on every keystroke.
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
-- ltex is LanguageTool (grammar/style/spelling for prose) wrapped as an LSP.
-- It is a JVM, so scope matters: "text" used to be in this list, which spawned
-- one for every plain-text scratch buffer and is the likely source of the
-- server-start timeouts. Restricted to the filetypes where prose checking is
-- actually the point.
vim.lsp.config("ltex", {
	filetypes = { "markdown", "tex", "latex" },
	settings = {
		ltex = {
			language = "en-GB",
		},
	},
})

-- kept for buffers outside those filetypes, or to restart it by hand
vim.api.nvim_create_user_command("LtexStart", function()
	vim.lsp.enable("ltex")
	local cfg = vim.lsp.config["ltex"]
	if cfg then
		vim.lsp.start(cfg, { bufnr = 0 })
	end
end, { desc = "Start ltex grammar checking for this buffer" })

-- Find the interpreter pyright should use. The old version only checked
-- .venv/venv/.env directly under the root, so uv, poetry and any activated
-- env silently fell back to the system python -- which is exactly when pyright
-- starts reporting imports it cannot resolve.
local function venv_python(root)
	-- 1. an activated environment always wins
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

	-- 3. in-tree virtualenvs (uv and plain venv both put one here)
	for _, name in ipairs({ ".venv", "venv", ".env" }) do
		local exe = root .. "/" .. name .. "/bin/python"
		if vim.uv.fs_stat(exe) then
			return exe
		end
	end

	-- 4. poetry keeps its venvs out of tree; ask it. Only when this actually
	-- looks like a poetry project, since `poetry env info` is a slow subprocess.
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

-- basedpyright, not pyright: it is the fork that actually implements inlay
-- hints. The config below used to be attached to "pyright", which is no longer
-- in config/servers.lua -- so none of it was applying. That is the most likely
-- source of the spurious inheritance errors: with no pythonPath, basedpyright
-- was analysing against the system interpreter and its stdlib, not your venv.
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
		local root = config.root_dir or params.rootPath or vim.fn.getcwd()
		local exe = venv_python(root)
		config.settings.basedpyright.pythonPath = exe

		-- Pin the language version to the interpreter's own, so basedpyright
		-- cannot analyse 3.12 code against a 3.9 stdlib (or vice versa).
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

				-- basedpyright defaults to "recommended", which turns on the
				-- whole reportUnknown* family and reportMissingParameterType.
				-- On untyped code that is thousands of warnings saying "this is
				-- not annotated", which is noise rather than signal.
				-- "standard" matches what pyright gave you before.
				typeCheckingMode = "standard",

				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
				},

				-- the few "recommended" rules worth keeping off explicitly, in
				-- case a project's own pyrightconfig turns the mode back up
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
		-- NOTE: "--std=c++20" used to be here. It is a *compiler* flag, not a
		-- clangd one -- clangd rejected it and exited 1 on every C/C++ file, so
		-- the server has never actually run. Set the standard in
		-- compile_commands.json, compile_flags.txt or a .clangd file instead.
		"--limit-results=50",
		"--compile-commands-dir=.",
		"--pch-storage=memory",
	},
	-- replaces lspconfig.util.root_pattern(), which is deprecated
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
			-- these were all false, so clangd sent no hints regardless of what
			-- nvim asked for. Turn them on now that hints are enabled on attach.
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
		-- updatetime is global and now lives in config/options.lua
		if vim.api.nvim_buf_line_count(bufnr) > 1000 then
			client.server_capabilities.documentHighlightProvider = nil
		end
	end,
})

-- ruff does linting + import sorting + formatting. pyright keeps types and
-- hover; disabling ruff's hover stops the two duplicating every docstring.
vim.lsp.config("ruff", {
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
})

-- eslint reads the project's own .eslintrc/flat config, which is the whole
-- point: prettier alone cannot know your project's rules. Previously eslint was
-- installed via mason and then never enabled.
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

-- One TypeScript server, not two. vtsls is the better-maintained wrapper and
-- was already installed via mason while ts_ls was the one actually wired up.
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

-- eslint is simply absent from config/servers.lua; there is no "enable" field
-- on vim.lsp.config, so the old `{ enable = false }` here did nothing.

vim.filetype.add({
	extension = {
		fs = "glsl",
		vs = "glsl",
	},
})

-- one list, shared with mason's ensure_installed -- see lua/config/servers.lua
vim.lsp.enable(require("config.servers"))

-- Signature help. The second vim.lsp.with() call that used to be here threw its
-- result away and did nothing.
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })

-- Registered here rather than in the nvim-lspconfig spec: vim.lsp.enable() can
-- attach a client before that plugin's config function has run.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
	desc = "LSP actions",
	callback = function(event)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		-- inlay hints on by default; <leader>ih (Snacks.toggle) turns them off
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
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
		map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>ld", vim.diagnostic.open_float, "Show Diagnostic")
		-- vim.diagnostic.goto_prev/next are deprecated on 0.11
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous Diagnostic")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next Diagnostic")
	end,
})

vim.lsp.set_log_level("WARN")

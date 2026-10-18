-- Julia repos declare their formatter in one of three ways, and each needs its
-- own tool to reproduce it:
--   .JuliaFormatter.toml     -> jlfmt (the language server never reads this file)
--   Runic in CI / pre-commit -> runic (it has no config file of its own)
--   JuliaFormat.toml         -> the language server
-- Both CLIs are Julia apps in ~/.julia/bin: `pkg> app add JuliaFormatter Runic`.
local function uses_runic(root)
	local files = vim.fn.glob(root .. "/.github/workflows/*.y*ml", false, true)
	table.insert(files, root .. "/.pre-commit-config.yaml")
	for _, f in ipairs(files) do
		if vim.uv.fs_stat(f) then
			for _, line in ipairs(vim.fn.readfile(f)) do
				if line:lower():find("runic", 1, true) then
					return true
				end
			end
		end
	end
	return false
end

---@return "jlfmt"|"runic"|"lsp"|nil nil when the repo declares no style
local function julia_style(bufnr)
	if vim.fs.root(bufnr, ".JuliaFormatter.toml") then
		return "jlfmt"
	end
	if vim.fs.root(bufnr, "JuliaFormat.toml") then
		return "lsp"
	end
	local root = vim.fs.root(bufnr, ".git")
	if root and uses_runic(root) then
		return "runic"
	end
end

return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },

		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- ruff replaces black + isort: one tool, and "isort" was listed
				-- here but never installed, so import sorting never ran
				python = { "ruff_organize_imports", "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				tex = { "latexindent" },
				plaintex = { "latexindent" },
				bib = { "bibtex-tidy" },
				markdown = { "injected" },
				quarto = { "injected" },
				-- neither available -> lsp_fallback formats via julials
				julia = { "jlfmt", "runic", stop_after_first = true },
			},
			formatters = {
				jlfmt = {
					command = "jlfmt",
					args = function(_, ctx)
						return { "--config-dir=" .. ctx.dirname }
					end,
					condition = function(_, ctx)
						return julia_style(ctx.buf) == "jlfmt"
					end,
				},
				runic = {
					condition = function(_, ctx)
						return julia_style(ctx.buf) == "runic"
					end,
				},
			},
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype
				if ft == "markdown" or ft == "quarto" then
					return nil
				end
				-- whole-file reformatting in someone else's repo is a noisy diff, so
				-- julia only formats on save where the repo declares a style;
				-- <leader>lf still formats anywhere. jlfmt is a ~1s julia startup.
				if ft == "julia" then
					if not julia_style(bufnr) then
						return nil
					end
					return { timeout_ms = 5000, lsp_fallback = true }
				end
				return { lsp_fallback = true }
			end,
		},
	},
}

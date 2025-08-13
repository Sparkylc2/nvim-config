local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "SessionLoadPost",
			nested = true,
			callback = function()
				vim.schedule(function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(buf) then
							vim.api.nvim_buf_call(buf, function()
								vim.cmd("silent! filetype detect")
								vim.cmd("silent! doautocmd <nomodeline> FileType")
								pcall(vim.cmd, "silent! TSEnable highlight")
							end)
						end
					end
				end)
			end,
		})
	end,
})

local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"
local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}
local vtsls_config = {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = tsserver_filetypes,
}

local ts_ls_config = {
	init_options = {
		plugins = {
			vue_plugin,
		},
	},
	filetypes = tsserver_filetypes,
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = false },
				variableTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				functionLikeReturnTypes = { enabled = false },
				enumMemberValues = { enabled = false },
			},
		},
	},
}

local vue_ls_config = {}
vim.lsp.config("vtsls", vtsls_config)
vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.config("ts_ls", ts_ls_config)

vim.lsp.enable({
	"lua_ls",
	"vue_ls",
	"vtsls",
	"cssls",
	"tailwindcss",
	"html",
	"clangd",
	"pyright",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		pcall(function()
			vim.lsp.inlay_hint.enable(args.buf, false)
		end)
	end,
})

vim.keymap.set("n", "<leader>ih", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok_is_enabled, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
	if not ok_is_enabled then
		is_enabled = false
	end
	pcall(vim.lsp.inlay_hint.enable, bufnr, not is_enabled)
end, { desc = "Toggle Inlay Hints" })

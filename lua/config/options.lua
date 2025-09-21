local opt = vim.opt
local g = vim.g

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
vim.wo.cursorline = true
vim.o.laststatus = 3

-- Behavior
g.loaded_netrwPlugin = 1
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = (os.getenv("HOME") or "") .. "/.vim/undodir"
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 300
opt.ttimeout = true
opt.ttimeoutlen = 10
opt.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.maxmempattern = 200000
opt.lazyredraw = true
opt.synmaxcol = 200
vim.o.winborder = "rounded"
-- Clipboard
opt.clipboard = "unnamedplus"

-- Cursor
opt.cursorline = true
opt.cursorlineopt = "number"

-- Copilot configuration
g.copilot_no_tab_map = true
g.copilot_assume_mapped = true
g.copilot_idle_delay = 250

-- Disable built-in plugins
for _, plugin in pairs({
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
}) do
	vim.g["loaded_" .. plugin] = 1
end

-- Diagnostics

vim.diagnostic.enable()
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = true,
	underline = true,
	update_in_insert = false,
	float = { border = "rounded", source = "always" },
	severity_sort = true,
})

-- lsp
vim.lsp.enable({
	"vue_ls",
	"ts_ls",
	"lua_ls",
	"cssls",
	"tailwindcss",
	"html",
	"clangd",
	"pyright",
})

-- Signature help
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })
vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })

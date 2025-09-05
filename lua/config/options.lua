-- ==== options ===============================================================
local opt = vim.opt
local g = vim.g

-- indentation
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- line numbers
opt.number = true
opt.relativenumber = false

-- search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
vim.o.laststatus = 3

-- behavior
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = (os.getenv("HOME") or "") .. "/.vim/undodir"
opt.updatetime = 150
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

-- clipboard
opt.clipboard = "unnamedplus"

-- cursor
opt.cursorline = true
opt.cursorlineopt = "number"

-- copilot pacing
g.copilot_no_tab_map = true
g.copilot_assume_mapped = true
g.copilot_idle_delay = 250

-- disable built-ins
for _, plugin in pairs({
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
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

-- diagnostics
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "always" },
})

-- signature help
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { update_in_insert = false })

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

-- behavior
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.updatetime = 200
opt.timeout = true
opt.timeoutlen = 300
opt.ttimeout = true
opt.ttimeoutlen = 10
vim.o.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.maxmempattern = 200000
opt.lazyredraw = true
opt.ttyfast = true
opt.synmaxcol = 200
opt.termguicolors = true

-- clipboard
opt.clipboard = "unnamedplus"

-- cursor
opt.cursorline = true

-- diagnostics
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})
-- fix clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- remove signature help
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	update_in_insert = false,
})

-- disable unused plugins
local disabled_built_ins = {
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
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

-- copilot behaviour
g.copilot_idle_delay = 150
g.copilot_no_tab_map = true

-- kitty behaviour
g.kitty_fast_forwarding = 1

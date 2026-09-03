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
opt.laststatus = 3
opt.cmdheight = 1

-- Behavior
g.loaded_netrwPlugin = 1
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = (os.getenv("HOME") or "") .. "/.vim/undodir"
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 250
opt.ttimeout = true
opt.ttimeoutlen = 25
opt.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.maxmempattern = 200000
opt.lazyredraw = false
opt.synmaxcol = 200
opt.winborder = "rounded"

opt.fillchars:append({
	vert = "│",
	horiz = "─",
	horizup = "┴",
	horizdown = "┬",
	vertleft = "┤",
	vertright = "├",
	verthoriz = "┼",
})
opt.clipboard = "unnamedplus"

opt.title = true
opt.titlestring = "%t"

-- Cursor
opt.cursorline = true
opt.cursorlineopt = "number"

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

-- python host
g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")
vim.b.slime_cell_delimiter = "# %%"

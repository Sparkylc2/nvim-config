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
opt.laststatus = 2
opt.cmdheight = 1

-- Behavior
g.loaded_netrwPlugin = 1
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = (os.getenv("HOME") or "") .. "/.vim/undodir"
-- clangd's on_attach used to set this to 400 (800 for files over 1000 lines)
-- via vim.bo[bufnr].updatetime, which throws -- updatetime is global. If C++
-- CursorHold work feels too eager, raise it here; it applies everywhere.
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 250
-- ttimeoutlen is the grace period for a *terminal key code* to arrive in full.
-- At 0, a split read of Alt+<key> (ESC then the char) is decoded as a bare <Esc>
-- followed by the char, which wrecks Alt mappings in terminal mode.
opt.ttimeout = true
opt.ttimeoutlen = 25
opt.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.maxmempattern = 200000
opt.lazyredraw = false
opt.synmaxcol = 200
opt.winborder = "rounded"
opt.clipboard = "unnamedplus"

-- Publish the current filename as the terminal title. tmux reads this as
-- #{pane_title} and uses it for the window name, so the tab bar shows the file
-- being edited rather than just "nvim".
opt.title = true
opt.titlestring = "%t"

-- Cursor
opt.cursorline = true
opt.cursorlineopt = "number"

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

-- python host
g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")
vim.b.slime_cell_delimiter = "# %%"

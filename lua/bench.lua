-- lua/bench.lua
local M = {}

-- ==== tiny utils ============================================================
local function ms()
	return vim.loop.hrtime() / 1e6
end
local function sleep(t)
	vim.loop.sleep(t)
end
local function tc(k)
	return vim.api.nvim_replace_termcodes(k, true, false, true)
end
local function feed(keys)
	vim.api.nvim_feedkeys(tc(keys), "n", false)
end -- no remaps, non-recursive

local function print_result(label, t0, t1)
	print(string.format("%-24s %6.0f ms", label .. ":", t1 - t0))
end

local function silent_ok(fn, ...)
	local ok, res = pcall(fn, ...)
	return ok, res
end

local function safe_cmd(cmd)
	vim.cmd.silent = true
	local ok = pcall(vim.cmd, "silent! " .. cmd)
	return ok
end

local function ensure_normal_modifiable()
	-- make current buffer a normal, listed, modifiable buffer
	vim.bo.buftype = ""
	vim.bo.buflisted = true
	vim.bo.swapfile = false
	vim.bo.modifiable = true
	vim.bo.readonly = false
end

local function ensure_window_is_normal()
	-- make sure we’re not in a special window
	if vim.wo.winfixbuf then
		vim.wo.winfixbuf = false
	end
end

local function wait_lsp(timeout_ms)
	local t0 = ms()
	while ms() - t0 < timeout_ms do
		local ok, clients = pcall(vim.lsp.get_clients, { bufnr = 0 })
		if ok and clients and #clients > 0 then
			return true
		end
		sleep(50)
	end
	return false
end

-- ==== workload pieces =======================================================

local words = {
	"import",
	"class",
	"def",
	"return",
	"template",
	"std::vector",
	"auto",
	"constexpr",
	"lambda",
	"print",
	"include",
	"typename",
}
local function rand_word()
	return words[math.random(#words)]
end

-- Insert-mode typing that pops the completion menu and sometimes confirms.
local function insert_typing(duration_ms)
	local start = ms()
	feed("gg0i") -- go top-left and enter insert
	while ms() - start < duration_ms do
		feed(rand_word() .. " ")
		feed("<C-Space>") -- show completion
		sleep(12)
		feed("<C-n><C-p>") -- navigate menu (forces sorting work)
		if math.random() < 0.35 then
			feed("<CR>") -- actually confirm a completion sometimes
		end
		-- poke snippet/autopairs paths without assuming they exist
		feed("<Tab><S-Tab>")
		feed("<CR>") -- newline -> treesitter/diagnostics redraw
	end
	feed("<Esc>")
end

-- Do edits & writes to trigger diagnostics, BufWritePost & FS watchers
local function edit_write_loop(lines_per, loops)
	for _ = 1, loops do
		feed("gg")
		feed("O") -- open a line above
		for _ = 1, lines_per do
			feed("x") -- add a char
			feed("<CR>")
		end
		feed("<Esc>")
		safe_cmd("silent! write") -- trigger write autocmds
		sleep(50)
	end
end

-- Stress UI redraws: splits + multiple buffers with different filetypes
local function splits_and_buffers()
	safe_cmd("silent! vsplit | wincmd l")
	safe_cmd("silent! split  | wincmd j")
	for _, ft in ipairs({ "cpp", "python", "lua", "markdown" }) do
		safe_cmd("enew")
		ensure_normal_modifiable()
		safe_cmd("setlocal ft=" .. ft)
		safe_cmd("file dummy_" .. ft)
	end
	-- bounce
	for _ = 1, 6 do
		safe_cmd("wincmd w")
	end
	safe_cmd("wincmd t")
end

local function poke_neotree_if_present()
	if vim.fn.exists(":Neotree") == 2 then
		safe_cmd("Neotree reveal")
		sleep(150)
		safe_cmd("Neotree close")
	end
end

-- Optionally force hard redraws
local function hard_redraw()
	safe_cmd("redraw!")
	safe_cmd("redrawstatus")
end

local function open_target(file)
	ensure_window_is_normal()
	safe_cmd("edit " .. vim.fn.fnameescape(file))
	ensure_normal_modifiable()
end

-- ==== per-language run ======================================================

local function run_lang_bench(file)
	math.randomseed(os.time())
	local T0 = ms()

	local t

	t = ms()
	open_target(file)
	print_result("open " .. file, t, ms())

	t = ms()
	wait_lsp(2000)
	print_result("wait lsp", t, ms())

	t = ms()
	insert_typing(4000)
	hard_redraw()
	print_result("insert w/ completion", t, ms())

	t = ms()
	edit_write_loop(6, 3)
	hard_redraw()
	print_result("edit/write + diagnostics", t, ms())

	t = ms()
	splits_and_buffers()
	hard_redraw()
	print_result("splits + buffers", t, ms())

	t = ms()
	poke_neotree_if_present()
	print_result("neo-tree poke", t, ms())

	t = ms()
	insert_typing(1000)
	print_result("insert tail", t, ms())

	print_result("TOTAL", T0, ms())
end

-- ==== public ================================================================

function M.run(opts)
	opts = opts or {}
	-- Silence as much noise as possible in headless
	vim.opt.shortmess:append("atIcF") -- avoid hit-enter, intro, etc.
	vim.opt.more = false
	vim.opt.cmdheight = 0
	vim.opt.showmode = false
	vim.opt.ruler = false
	vim.opt.hlsearch = false

	local files = opts.files or { "main.py", "main.cpp" }

	for _, file in ipairs(files) do
		run_lang_bench(file)
		print("---")
	end
end

return M

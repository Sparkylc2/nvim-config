-- Julia REPL in a split beside the code, one per project, fed through
-- bracketed paste so multi-line blocks arrive as one input.
--
-- The keys mirror the Molten (Jupyter) ones under <leader>j and are
-- buffer-local, so they only shadow Molten inside julia buffers.

local M = {}

local win = {
	position = "right",
	width = 0.4,
	border = { "─", "", "", "", "", "", "", "" },
	wo = { winbar = "" },
	enter = false,
}

-- cells are delimited by `##` (the VS Code Julia convention) or `# %%`
local function is_marker(line)
	return line ~= nil and (line:match("^##") ~= nil or line:match("^%s*#%s*%%%%") ~= nil)
end

---The package root for buf. test/, docs/ etc. often carry their own
---Project.toml; the REPL belongs to the package above them.
local function project_root(buf)
	local root = vim.fs.root(buf, { "Project.toml", "JuliaProject.toml" })
	if root and vim.tbl_contains({ "test", "docs", "benchmark", "examples" }, vim.fs.basename(root)) then
		local parent = vim.fs.dirname(root)
		if vim.uv.fs_stat(parent .. "/Project.toml") then
			return parent
		end
	end
	return root
end

local function repl_spec(buf)
	local root = project_root(buf)
	local cwd = root or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p:h")
	local cmd = root and { "julia", "--project=" .. root } or { "julia" }
	return cmd, { cwd = cwd, win = win, start_insert = false, auto_insert = false }
end

---The REPL for the current buffer, started (or re-shown) if needed.
local function repl()
	local cmd, opts = repl_spec(0)
	local term = Snacks.terminal.get(cmd, opts)
	if not term:valid() then
		term:show()
	end
	return term
end

local function send(text)
	if text:match("^%s*$") then
		return
	end
	local term = repl()
	vim.api.nvim_chan_send(vim.bo[term.buf].channel, "\27[200~" .. text .. "\27[201~\r")
	vim.api.nvim_win_call(term.win, function()
		vim.cmd("normal! G")
	end)
end

local function send_lines(first, last)
	send(table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n"))
end

local function send_cell()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local start = cur
	while start > 1 and not is_marker(lines[start]) do
		start = start - 1
	end
	local stop = cur + 1
	while stop <= #lines and not is_marker(lines[stop]) do
		stop = stop + 1
	end
	send_lines(is_marker(lines[start]) and start + 1 or start, stop - 1)

	-- step onto the next cell, like shift-enter in a notebook
	if stop <= #lines then
		vim.api.nvim_win_set_cursor(0, { math.min(stop + 1, #lines), 0 })
	end
end

local function send_selection()
	local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	send(table.concat(text, "\n"))
end

local function toggle()
	local cmd, opts = repl_spec(0)
	Snacks.terminal.toggle(cmd, opts)
end

local function interrupt()
	local cmd, opts = repl_spec(0)
	local term = Snacks.terminal.get(cmd, vim.tbl_extend("force", opts, { create = false }))
	if term then
		vim.api.nvim_chan_send(vim.bo[term.buf].channel, "\3")
	end
end

local function restart()
	local cmd, opts = repl_spec(0)
	local term = Snacks.terminal.get(cmd, vim.tbl_extend("force", opts, { create = false }))
	if term then
		vim.cmd("bwipeout! " .. term.buf)
	end
	repl()
end

-- Auto `end`: pressing Enter after `function f(x)`, `if c`, `xs do x` etc. adds
-- the matching `end` below. It watches for the new blank line rather than
-- mapping <CR>, which nvim-autopairs already owns.

local openers = {
	"function",
	"macro",
	"struct",
	"module",
	"baremodule",
	"if",
	"for",
	"while",
	"let",
	"begin",
	"quote",
	"try",
	"do",
}

local block_types = {
	function_definition = true,
	macro_definition = true,
	struct_definition = true,
	module_definition = true,
	if_statement = true,
	for_statement = true,
	while_statement = true,
	let_statement = true,
	compound_statement = true,
	quote_statement = true,
	try_statement = true,
	do_clause = true,
}

---The last block keyword on row (0-based) that is a real keyword token, not
---part of a string, comment or identifier.
local function opener_on(root, row, text)
	local found
	for _, kw in ipairs(openers) do
		local init = 1
		while true do
			local s, e = text:find("%f[%w_]" .. kw .. "%f[^%w_]", init)
			if not s then
				break
			end
			local node = root:descendant_for_range(row, s - 1, row, e)
			-- an unclosed `begin` parses as an identifier (as in a[begin]); count it
			-- when it starts a statement: line start, after `=`, or after a macro
			local before = text:sub(1, s - 1)
			local bare_begin = kw == "begin"
				and node
				and node:type() == "identifier"
				and (before:match("^%s*$") or before:match("=%s*$") or before:match("@[%w_.]+%s*$"))
			if node and (node:type() == kw or bare_begin) and (not found or s > found.col) then
				found = { node = node, col = s }
			end
			init = e + 1
		end
	end
	return found and found.node
end

---Unclosed when tree-sitter could not finish the block, or when its `end` was
---borrowed from an enclosing block (so it sits at a different indent).
local function is_unclosed(kw, row, indent)
	if kw:type() == "identifier" then
		return true
	end
	local block = kw:parent()
	while block and not block_types[block:type()] and block:type() ~= "ERROR" do
		block = block:parent()
	end
	if not block then
		return false
	end
	if block:type() == "ERROR" then
		return true
	end
	local last = block:child(block:child_count() - 1)
	if not last or last:type() ~= "end" or last:missing() then
		return true
	end
	local end_row, end_col = last:start()
	return end_row ~= row and end_col ~= #indent
end

local function auto_end(buf)
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	if row < 1 or vim.api.nvim_get_current_line():match("%S") then
		return
	end
	local prev = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
	local indent = prev:match("^%s*")

	-- already closed by hand: the next code line is `end` at the opener's indent
	for _, l in ipairs(vim.api.nvim_buf_get_lines(buf, row + 1, -1, false)) do
		if l:match("%S") then
			if l:match("^%s*") == indent and l:match("^%s*end%f[^%w_]") then
				return
			end
			break
		end
	end

	local ok, parser = pcall(vim.treesitter.get_parser, buf, "julia")
	if not ok or not parser then
		return
	end
	local root = parser:parse()[1]:root()
	local kw = opener_on(root, row - 1, prev)
	if kw and is_unclosed(kw, row - 1, indent) then
		vim.api.nvim_buf_set_lines(buf, row + 1, row + 1, false, { indent .. "end" })
	end
end

local function map(buf, mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Julia: " .. desc })
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("JuliaRepl", { clear = true }),
		pattern = "julia",
		callback = function(args)
			local buf = args.buf
			local group = vim.api.nvim_create_augroup("JuliaAutoEnd" .. buf, { clear = true })
			vim.api.nvim_create_autocmd("TextChangedI", {
				group = group,
				buffer = buf,
				callback = function()
					auto_end(buf)
				end,
			})
			-- `o` opens its line without a TextChangedI, and only after InsertEnter
			vim.api.nvim_create_autocmd("InsertEnter", {
				group = group,
				buffer = buf,
				callback = function()
					vim.schedule(function()
						auto_end(buf)
					end)
				end,
			})

			map(buf, "n", "<leader>ji", toggle, "toggle REPL")
			map(buf, "n", "<leader>jl", function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				send_lines(row, row)
			end, "run line")
			map(buf, "x", "<leader>jv", send_selection, "run selection")
			map(buf, "n", "<leader>jc", send_cell, "run cell and advance")
			map(buf, "n", "<leader>jf", function()
				send(("include(%q)"):format(vim.api.nvim_buf_get_name(0)))
			end, "include file")
			map(buf, "n", "<leader>jt", function()
				send("import Pkg; Pkg.test()")
			end, "run package tests")
			map(buf, "n", "<leader>jx", interrupt, "interrupt")
			map(buf, "n", "<leader>jR", restart, "restart REPL")
		end,
	})
end

return M

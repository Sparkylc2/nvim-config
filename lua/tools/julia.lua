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

local function map(buf, mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Julia: " .. desc })
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("JuliaRepl", { clear = true }),
		pattern = "julia",
		callback = function(args)
			local buf = args.buf
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

-- :JupyterKernel below registers one for the current project's venv, and
-- MoltenInit picks the matching kernel automatically.

local function is_fenced()
	local ft = vim.bo.filetype
	return ft == "markdown" or ft == "quarto"
end

local function is_percent(line)
	return line ~= nil and line:match("^%s*#%s*%%%%") ~= nil
end

local function is_fence(line)
	return line ~= nil and line:match("^%s*```") ~= nil
end

local function fence_at(lines, cur)
	local i = 1
	while i <= #lines do
		if is_fence(lines[i]) then
			local open = i
			local close = i + 1
			while close <= #lines and not is_fence(lines[close]) do
				close = close + 1
			end
			if cur >= open and cur <= close then
				return open, math.min(close, #lines + 1)
			end
			i = close + 1
		else
			i = i + 1
		end
	end
end

local function cell_bounds()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	if is_fenced() then
		local open, close = fence_at(lines, cur)
		if not open then
			return nil
		end
		return open + 1, close - 1
	end

	local start = cur
	while start > 1 and not is_percent(lines[start]) do
		start = start - 1
	end
	-- the marker line itself is not code
	local first = is_percent(lines[start]) and start + 1 or start

	local stop = cur + 1
	while stop <= #lines and not is_percent(lines[stop]) do
		stop = stop + 1
	end
	return first, stop - 1
end

local function eval_cell()
	local first, last = cell_bounds()
	if not first then
		vim.notify("not inside a code cell", vim.log.levels.WARN)
		return
	end
	if first > last then
		vim.notify("empty cell", vim.log.levels.WARN)
		return
	end
	vim.fn.MoltenEvaluateRange(first, last)
end

local function goto_cell(dir)
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	if is_fenced() then
		local opens, i = {}, 1
		while i <= #lines do
			if is_fence(lines[i]) then
				opens[#opens + 1] = i
				local close = i + 1
				while close <= #lines and not is_fence(lines[close]) do
					close = close + 1
				end
				i = close + 1
			else
				i = i + 1
			end
		end
		local target
		for _, open in ipairs(opens) do
			if dir > 0 and open + 1 > cur then
				target = open + 1
				break
			elseif dir < 0 and open + 1 < cur then
				target = open + 1
			end
		end
		if target then
			vim.api.nvim_win_set_cursor(0, { math.min(target, #lines), 0 })
			return
		end
	else
		local i = cur + dir
		while i >= 1 and i <= #lines do
			if is_percent(lines[i]) then
				vim.api.nvim_win_set_cursor(0, { i, 0 })
				return
			end
			i = i + dir
		end
	end
	vim.notify(dir > 0 and "no next cell" or "no previous cell", vim.log.levels.INFO)
end

---The kernel whose interpreter lives under the current project, if there is one.
local function project_kernel()
	local root = vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()
	local dir = vim.fn.expand("~/Library/Jupyter/kernels")
	for name, t in vim.fs.dir(dir) do
		if t == "directory" then
			local ok, spec =
				pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(dir .. "/" .. name .. "/kernel.json"), ""))
			if ok and spec and spec.argv and spec.argv[1] and spec.argv[1]:find(root, 1, true) then
				return name
			end
		end
	end
end

local function register_kernel()
	local root = vim.fs.root(0, { "pyproject.toml", "setup.py", ".git" }) or vim.fn.getcwd()
	local name = vim.fn.fnamemodify(root, ":t")

	local py
	for _, candidate in ipairs({ "/.venv/bin/python", "/venv/bin/python", "/.env/bin/python" }) do
		if vim.uv.fs_stat(root .. candidate) then
			py = root .. candidate
			break
		end
	end
	if not py and vim.env.VIRTUAL_ENV then
		py = vim.env.VIRTUAL_ENV .. "/bin/python"
	end
	if not py then
		vim.notify("No venv found under " .. root .. " -- create one first", vim.log.levels.ERROR)
		return
	end

	-- ipykernel must be IN the venv; it is what the kernel actually runs
	vim.fn.system({ py, "-c", "import ipykernel" })
	if vim.v.shell_error ~= 0 then
		local uv_project = vim.uv.fs_stat(root .. "/uv.lock") ~= nil
		vim.notify("Installing ipykernel into " .. py, vim.log.levels.INFO)
		if uv_project then
			vim.fn.system({ "uv", "pip", "install", "--python", py, "-q", "ipykernel" })
		else
			vim.fn.system({ py, "-m", "pip", "install", "-q", "ipykernel" })
		end
		if vim.v.shell_error ~= 0 then
			vim.notify("installing ipykernel failed", vim.log.levels.ERROR)
			return
		end
		if uv_project then
			vim.notify(
				"uv project: the next `uv sync` removes ipykernel again unless it is declared.\n"
					.. "Use `uv add --dev ipykernel`, or sync the extra that declares it.",
				vim.log.levels.WARN
			)
		end
	end

	vim.fn.system({ py, "-m", "ipykernel", "install", "--user", "--name", name, "--display-name", name .. " (venv)" })
	if vim.v.shell_error == 0 then
		vim.notify("Kernel '" .. name .. "' -> " .. py, vim.log.levels.INFO)
	else
		vim.notify("Failed to register kernel", vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_user_command("JupyterKernel", register_kernel, {
	desc = "Register a Jupyter kernel for this project's venv",
})

-- Explicit conversion, for when you want a real .py on disk rather than the
-- transparent view: :JupyterToPy [file]  ->  writes <file>.py in percent format.
vim.api.nvim_create_user_command("JupyterToPy", function(a)
	local nb = a.args ~= "" and a.args or vim.api.nvim_buf_get_name(0)
	if not nb:match("%.ipynb$") then
		vim.notify("not an .ipynb: " .. nb, vim.log.levels.ERROR)
		return
	end
	local out = vim.fn.system({ "jupytext", "--to", "py:percent", nb })
	if vim.v.shell_error == 0 then
		vim.notify("wrote " .. nb:gsub("%.ipynb$", ".py"), vim.log.levels.INFO)
	else
		vim.notify("jupytext failed: " .. out, vim.log.levels.ERROR)
	end
end, { nargs = "?", complete = "file", desc = "Convert an .ipynb to percent-format .py" })

local function molten_highlights()
	local hl = vim.api.nvim_set_hl
	local red, orange, yellow = "#FF5D62", "#FFA066", "#FF9E3B"
	local green, blue, violet = "#98BB6C", "#7E9CD8", "#957FB8"
	local gray, dim = "#727169", "#54546D"

	hl(0, "MoltenOutputBorder", { fg = dim })
	hl(0, "MoltenOutputBorderSuccess", { fg = green })
	hl(0, "MoltenOutputBorderFail", { fg = red })
	hl(0, "MoltenOutputFooter", { fg = gray, italic = true })
	hl(0, "MoltenVirtualText", { fg = "#A6A69C" })

	hl(0, "MoltenOutRule", { fg = dim })
	hl(0, "MoltenOutExc", { fg = red, bold = true })
	hl(0, "MoltenOutWarn", { fg = yellow })
	hl(0, "MoltenOutFrame", { fg = blue })
	hl(0, "MoltenOutArrow", { fg = red, bold = true })
	hl(0, "MoltenOutLineNr", { fg = gray })
	hl(0, "MoltenOutNum", { fg = orange })
	hl(0, "MoltenOutConst", { fg = violet })
	hl(0, "MoltenOutStr", { fg = green })
end

-- Molten's setup guide is explicit that the image provider's size caps must be
-- set (an uncapped plot can crash the terminal) and recommends 100x12: wide
-- enough for a matplotlib figure, short enough that a cell's output does not
-- shove the rest of the buffer off screen. It also insists the provider apply
-- no window-relative cap on top -- Molten opens an output window exactly as
-- tall as it needs, so a percentage cap makes the window and the image
-- disagree. snacks has no window-percentage option, and with a cap of 12 the
-- clamp to window height in snacks' placement never binds, so the guide's
-- advice carries over directly.
--
-- These are deliberately Molten's own, NOT Snacks.config.image.doc: those
-- govern figures in prose, which should be free to be taller than a cell
-- output.
local MAX_WIDTH = 100
local MAX_HEIGHT = 12

local MOLTEN_GUARD_OLD = [[        if (
            self.selected_cell is not None
            # Prevent from rendering when it's done
            and self.output_statuses.get(self.selected_cell, None) != OutputStatus.DONE
        ):]]

local MOLTEN_GUARD_NEW = [[        if self.selected_cell is not None:]]

local function patch_output_regression()
	local file = vim.fn.stdpath("data") .. "/lazy/molten-nvim/rplugin/python3/molten/moltenbuffer.py"
	local fd = io.open(file, "r")
	if not fd then
		return
	end
	local src = fd:read("*a")
	fd:close()
	if not src:find(MOLTEN_GUARD_OLD, 1, true) then
		return
	end
	local out = src:gsub(vim.pesc(MOLTEN_GUARD_OLD), (MOLTEN_GUARD_NEW:gsub("%%", "%%%%")), 1)
	local w = io.open(file, "w")
	if not w then
		return
	end
	w:write(out)
	w:close()
	vim.notify("molten: patched output-window regression; restart nvim", vim.log.levels.WARN)
end
--
local function patch_snacks_bridge()
	local ok, mod = pcall(require, "load_snacks_nvim")
	if not ok or type(mod) ~= "table" or type(mod.snacks_api) ~= "table" then
		return
	end
	local api = mod.snacks_api
	local store = {}

	api.from_file = function(path, opts)
		local id = opts.id or path
		local row, col = opts.y, opts.x
		local prev = store[id]
		if
			prev
			and prev.src == path
			and prev.buffer == opts.buffer
			and prev.opts.pos[1] == row
			and prev.opts.pos[2] == col
		then
			return id
		end
		if prev and prev.placement then
			pcall(function()
				prev.placement:close()
			end)
		end
		store[id] = {
			src = path,
			buffer = opts.buffer,
			opts = {
				inline = true,
				pos = { row, col },
				max_width = MAX_WIDTH,
				max_height = MAX_HEIGHT,
			},
		}
		return id
	end

	api.render = function(id)
		local e = store[id]
		if e and not e.placement then
			e.placement = Snacks.image.placement.new(e.buffer, e.src, e.opts)
		end
	end

	api.clear = function(id)
		local e = store[id]
		if e and e.placement then
			pcall(function()
				e.placement:close()
			end)
			e.placement = nil
		end
	end

	api.clear_all = function()
		for id in pairs(store) do
			api.clear(id)
		end
	end

	-- Molten sizes the output float from this estimate before the placement
	-- exists, so it has to use the exact caps the placement will use --
	-- otherwise the float and the image disagree.
	api.image_size = function(id)
		local e = store[id]
		if not e then
			return { width = 0, height = 0 }
		end
		return Snacks.image.util.fit(e.src, { width = e.opts.max_width, height = e.opts.max_height })
	end
end

return {
	{
		"benlubas/molten-nvim",
		-- main, NOT the v1.9.2 tag: the snacks.nvim image provider landed on main
		-- in May 2025 and has never been released. On the tag it falls back to
		-- NoCanvas, so no images render at all.
		branch = "main",
		dependencies = { "folke/snacks.nvim" },
		build = ":UpdateRemotePlugins",
		ft = { "python", "markdown" },
		init = function()
			vim.g.molten_image_provider = "snacks.nvim"
			vim.g.molten_image_location = "float"

			vim.g.molten_auto_open_output = true
			vim.g.molten_virt_text_output = false
			vim.g.molten_output_virt_lines = true
			vim.g.molten_wrap_output = true

			vim.g.molten_enter_output_behavior = "open_and_enter"
			vim.g.molten_output_win_max_height = 24
			vim.g.molten_output_win_hide_on_leave = false
			vim.g.molten_output_show_more = true
			vim.g.molten_floating_window_focus = "bottom"

			vim.g.molten_cover_empty_lines = true
			vim.g.molten_cover_lines_starting_with = { "```" }

			vim.g.molten_use_border_highlights = true
		end,
		config = function()
			molten_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = molten_highlights })
			-- patch_output_regression()
			patch_snacks_bridge()

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "molten_output",
				callback = function(ev)
					vim.api.nvim_buf_call(ev.buf, function()
						vim.cmd([[
							syn clear
							syn match MoltenOutRule   /^-\{20,}$/
							syn match MoltenOutExc    /^\a\w*\%(Error\|Exception\|Interrupt\|Exit\)\>.*/
							syn match MoltenOutWarn   /^.*\<\%(Warning\|WARNING\|Deprecat\w*\)\>.*/
							syn match MoltenOutFrame  /^\%(File\|Cell In\).*/
							syn match MoltenOutArrow  /^-*> *\d\+/
							syn match MoltenOutLineNr /^ \+\d\+ /
							syn match MoltenOutConst  /\<\%(True\|False\|None\|nan\|inf\)\>/
							syn match MoltenOutNum    /\<\d\+\%(\.\d\+\)\?\%([eE][+-]\?\d\+\)\?\>/
							syn region MoltenOutStr   start=/'/ end=/'/ oneline
							syn region MoltenOutStr   start=/"/ end=/"/ oneline
						]])
					end)
				end,
			})
		end,
		keys = {
			{
				"<leader>ji",
				function()
					local k = project_kernel()
					if k then
						vim.cmd("MoltenInit " .. k)
					else
						vim.cmd("MoltenInit")
					end
				end,
				desc = "Jupyter: init kernel (auto-picks project venv)",
			},
			{ "<leader>jc", eval_cell, desc = "Jupyter: run cell" },
			{
				"<leader>jC",
				function()
					eval_cell()
					goto_cell(1)
				end,
				desc = "Jupyter: run cell + advance",
			},
			{ "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Jupyter: run line" },
			{ "<leader>jv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Jupyter: run selection" },
			{ "<leader>jr", "<cmd>MoltenReevaluateCell<cr>", desc = "Jupyter: re-run cell" },
			{ "<leader>jo", "<cmd>MoltenShowOutput<cr>", desc = "Jupyter: show output" },
			{ "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Jupyter: hide output" },
			{ "<leader>je", "<cmd>MoltenEnterOutput<cr>", desc = "Jupyter: enter output" },
			{ "<leader>jx", "<cmd>MoltenInterrupt<cr>", desc = "Jupyter: interrupt kernel" },
			{ "<leader>jy", "<cmd>MoltenYankOutput<cr>", desc = "Jupyter: yank cell output" },
			{ "<leader>jd", "<cmd>MoltenDelete<cr>", desc = "Jupyter: delete cell output" },
			{ "<leader>jR", "<cmd>MoltenRestart!<cr>", desc = "Jupyter: restart kernel" },
			{
				"]c",
				function()
					goto_cell(1)
				end,
				desc = "Next cell",
			},
			{
				"[c",
				function()
					goto_cell(-1)
				end,
				desc = "Previous cell",
			},
		},
	},

	-- opens .ipynb as percent format and writes it back as .ipynb
	{
		"GCBallesteros/jupytext.nvim",
		-- MUST be eager. jupytext registers its BufReadCmd for *.ipynb inside
		-- setup(), so it has to be loaded before you open the file. An `ft`
		-- trigger cannot work: a .ipynb has filetype "json", and by the time any
		-- filetype is set the read has already happened -- you get raw JSON.
		lazy = false,
		opts = {
			style = "markdown",
			-- "auto" would emit `--to=auto:markdown`, which jupytext rejects
			output_extension = "md",
			force_ft = "markdown",
		},
		config = function(_, opts)
			-- jupytext.nvim does metadata.kernelspec.language with no nil guard,
			-- so any notebook without a kernelspec (they exist -- notebooks
			-- generated by tools rather than by Jupyter) errors on open and you
			-- get raw JSON. Fall back to python instead of blowing up.
			local utils = require("jupytext.utils")
			local original = utils.get_ipynb_metadata
			utils.get_ipynb_metadata = function(filename)
				local ok, meta = pcall(original, filename)
				if ok and meta and meta.extension then
					return meta
				end
				return { language = "python", extension = "py" }
			end

			require("jupytext").setup(opts)
		end,
	},
}

-- Jupyter: percent cells in .py files, output inline including plots.
--
-- molten-nvim runs a real Jupyter kernel and renders output under the cell.
-- It supports snacks.nvim as an image provider, which you already have enabled
-- (plugins/ui/snacks.lua), so there is no image.nvim/luarocks dependency.
--
-- jupytext.nvim is here only so a .ipynb someone sends you opens as percent
-- format and saves back as .ipynb. Your own files should be plain .py.
--
-- THE THING THAT MAKES JUPYTER PAINFUL is kernels pointing at the wrong Python.
-- :JupyterKernel below registers one for the current project's venv, and
-- MoltenInit picks the matching kernel automatically.

---Find the `# %%` cell containing the cursor. Returns 1-indexed start,end lines.
local function cell_bounds()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local last = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local function is_marker(n)
		local l = lines[n]
		return l ~= nil and l:match("^%s*#%s*%%%%") ~= nil
	end

	local start = cur
	while start > 1 and not is_marker(start) do
		start = start - 1
	end
	-- the marker line itself is not code
	local first = is_marker(start) and start + 1 or start

	local stop = cur + 1
	while stop <= last and not is_marker(stop) do
		stop = stop + 1
	end
	return first, stop - 1
end

local function eval_cell()
	local first, last = cell_bounds()
	if first > last then
		vim.notify("empty cell", vim.log.levels.WARN)
		return
	end
	vim.fn.MoltenEvaluateRange(first, last)
end

local function goto_cell(dir)
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local n = #lines
	local i = cur + dir
	while i >= 1 and i <= n do
		if lines[i]:match("^%s*#%s*%%%%") then
			vim.api.nvim_win_set_cursor(0, { i, 0 })
			return
		end
		i = i + dir
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

---Register a Jupyter kernel for this project's venv, so notebooks run against
---the same interpreter (and therefore the same packages) as the LSP.
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
	if vim.fn.system({ py, "-c", "import ipykernel" }) and vim.v.shell_error ~= 0 then
		vim.notify("Installing ipykernel into " .. py, vim.log.levels.INFO)
		vim.fn.system({ py, "-m", "pip", "install", "-q", "ipykernel" })
		if vim.v.shell_error ~= 0 then
			vim.notify("pip install ipykernel failed", vim.log.levels.ERROR)
			return
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

return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		dependencies = { "folke/snacks.nvim" },
		build = ":UpdateRemotePlugins",
		ft = { "python", "markdown" },
		init = function()
			-- snacks.image does the rendering; nothing else to install
			vim.g.molten_image_provider = "snacks.nvim"
			vim.g.molten_output_win_max_height = 24
			vim.g.molten_auto_open_output = false -- virtual text, not a popup
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_wrap_output = true
			vim.g.molten_output_virt_lines = true
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
			{ "<leader>je", "<cmd>MoltenEnterOutput<cr>", desc = "Jupyter: enter output window" },
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
		ft = { "python", "markdown" },
		opts = {
			style = "percent",
			output_extension = "auto",
			force_ft = nil,
		},
	},
}

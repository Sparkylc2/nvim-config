local base_dir = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Year\\ 2/"
local uni_dirs = {
	ae = "Aerodynamics\\ 2",
	fd = "Flight\\ Dynamics\\ and\\ Control",
	math = "Mathematics\\ 2",
	exams = "Past\\ Exams",
	cs = "Computing\\ and\\ Numerical\\ Methods\\ 2",
	labs = "Lab\\ Reports",
	mech = "Mechatronics",
	pt = "Propulsion\\ and\\ Turbomachinery",
	ep = "Engineering\\ Practice\\ 2",
	mat = "Materials\\ 2",
	misc = "Misc",
	struc = "Structures\\ 2",
	h = "",
}

local function unescape_spaces(p)
	return (p or ""):gsub("\\ ", " ")
end

local function disable_copilot_when_ready(opts)
	opts = opts or {}
	local tries, max_try, delay = 0, opts.max_try or 40, opts.delay or 100
	vim.g.copilot_enabled = false
	vim.g.copilot_filetypes = vim.g.copilot_filetypes or {}
	vim.g.copilot_filetypes["*"] = false
	local function kill_lsp()
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.name == "copilot" then
				pcall(function()
					client.stop(true)
				end)
			end
		end
	end
	local function tick()
		tries = tries + 1
		local has_cmd = vim.fn.exists(":Copilot") == 2
		local ok_mod, copilot = pcall(require, "copilot")
		local ok_cmd_mod, cop_cmd = pcall(require, "copilot.command")
		if has_cmd then
			vim.cmd("silent! Copilot disable")
			kill_lsp()
			return
		end
		if ok_cmd_mod and type(cop_cmd.Disable) == "function" then
			pcall(cop_cmd.Disable)
			kill_lsp()
			return
		end
		if ok_mod and type(copilot.disable) == "function" then
			pcall(copilot.disable)
			kill_lsp()
			return
		end
		if tries < max_try then
			vim.defer_fn(tick, delay)
		else
			kill_lsp()
		end
	end
	tick()
end

local function has_real_buffers()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
			return true
		end
	end
	return false
end

vim.api.nvim_create_user_command("Uni", function(opts)
	local parts = vim.split(opts.args or "", " ", { trimempty = true })
	local key = parts[1]
	local flags = {}
	for i = 2, #parts do
		flags[parts[i]] = true
	end
	local open_in_finder = flags.open or false

	local sub = uni_dirs[key]
	if sub == nil then
		print("Please provide a valid Uni shortcut key (e.g. ae, fd, cs, h). Got:", key or "nil")
		return
	end

	local target = unescape_spaces(vim.fn.expand(base_dir .. (sub or "")))
	target = vim.fn.fnamemodify(target, ":p") -- absolute path

	pcall(vim.cmd, "silent! AutoSession save")

	pcall(vim.api.nvim_set_current_dir, target)
	pcall(vim.loop.chdir, vim.fn.getcwd())
	vim.cmd("cd " .. vim.fn.fnameescape(target))

	pcall(vim.cmd, "silent! AutoSession restore")
	if target:find("Computing and Numerical Methods 2", 1, true) then
		disable_copilot_when_ready({ max_try = 60, delay = 100 })
	end
	if open_in_finder then
		vim.fn.jobstart({ "open", target }, { detach = true })
	end
end, {
	nargs = "+",
	complete = function(_, _)
		local keys = vim.tbl_keys(uni_dirs)
		table.insert(keys, "open")
		return keys
	end,
})

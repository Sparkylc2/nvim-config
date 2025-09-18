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

local function disable_copilot_when_ready(opts)
	opts = opts or {}
	local tries = 0
	local max_try = opts.max_try or 40
	local delay = opts.delay or 100

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

vim.api.nvim_create_user_command("Uni", function(opts)
	local args = vim.split(opts.args, " ")
	local key = args[1]
	local open_in_finder = args[2] == "open"

	local uni_dir = uni_dirs[key]
	if uni_dir == nil then
		print("Please provide a valid Uni shortcut key", key)
		return
	end

	local target = base_dir .. uni_dir
	target = vim.fn.expand(target)

	-- Don't change global cwd, just navigate Neo-tree
	local old_notify = vim.notify
	vim.notify = function() end
	pcall(vim.cmd, "SessionRestore")
	vim.notify = old_notify

	-- Open Neo-tree at the target directory
	vim.schedule(function()
		require("neo-tree.command").execute({
			action = "show",
			source = "filesystem",
			dir = target,
			position = "current",
		})
	end)

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

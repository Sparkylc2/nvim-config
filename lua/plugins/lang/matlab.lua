vim.api.nvim_create_autocmd("FileType", {
	pattern = { "matlab" },
	callback = function()
		local matlab_term_id = 9 -- dedicated ID for MATLAB

		-- Start/toggle MATLAB terminal
		vim.keymap.set("n", "<leader>mt", function()
			local Terminal = require("toggleterm.terminal").Terminal
			local matlab = Terminal:new({
				id = matlab_term_id,
				cmd = "/Applications/MATLAB_R2024b.app/bin/matlab -nodesktop -nosplash",
				direction = "horizontal",
				hidden = false,
			})
			matlab:toggle()
		end, { buffer = true, desc = "Toggle MATLAB terminal" })

		-- Run current file in existing MATLAB session
		vim.keymap.set("n", "<leader>rm", function()
			local dir = vim.fn.expand("%:p:h")
			local filename = vim.fn.expand("%:t:r")
			if filename == "" then
				vim.notify("No file to run", vim.log.levels.WARN)
				return
			end

			local terms = require("toggleterm.terminal")
			local matlab = terms.get(matlab_term_id)

			if matlab == nil or not matlab:is_open() then
				vim.notify("Start MATLAB first with <leader>mt", vim.log.levels.WARN)
				return
			end

			-- Send commands to running MATLAB
			matlab:send(string.format("cd('%s')", dir))
			matlab:send(filename)
		end, { buffer = true, desc = "Run file in MATLAB terminal" })
	end,
})
vim.filetype.add({
	extension = {
		m = "matlab",
	},
})

return {
	{
		"daeyun/vim-matlab",

		event = "VeryLazy",
		ft = "matlab",
	},
}

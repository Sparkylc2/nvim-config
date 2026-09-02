return {
	{
		"GCBallesteros/jupytext.nvim",
		lazy = false,
		opts = {
			style = "percent",
			output_extension = "auto",
			force_ft = nil,
		},
	},

	{
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_target = "neovim"
			vim.g.slime_no_mappings = 1
			vim.g.slime_cell_delimiter = "# %%"
			vim.g.slime_suggest_default = 1
			vim.g.slime_bracketed_paste = 1

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc, silent = true })
			end

			map("n", "<leader>jo", function()
				vim.cmd("botright vsplit")
				vim.cmd("terminal uv run --with ipython ipython")
				vim.cmd("startinsert")
			end, "Jupyter: open ipython REPL")

			map("n", "<leader>js", "<Plug>SlimeConfig", "Jupyter: configure slime target")

			-- Core cell workflow.
			map("n", "<leader>jc", "<Plug>SlimeCellsSendAndGoToNext", "Jupyter: send cell + advance")
			map("n", "<leader>je", "<Plug>SlimeCellsSend", "Jupyter: send cell (stay)")
			map("n", "]c", "<Plug>SlimeCellsNext", "Next cell")
			map("n", "[c", "<Plug>SlimeCellsPrev", "Prev cell")

			-- Send granular pieces.
			map("n", "<leader>jl", "<Plug>SlimeLineSend", "Jupyter: send line")
			map("x", "<leader>j", "<Plug>SlimeRegionSend", "Jupyter: send selection")
		end,
	},

	{
		"Klafyvel/vim-slime-cells",
		dependencies = { "jpalardy/vim-slime" },
		init = function()
			vim.g.slime_cells_no_highlight = 0
		end,
	},
}

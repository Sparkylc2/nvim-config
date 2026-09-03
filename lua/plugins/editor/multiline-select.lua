return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*",
	opts = {},

	config = function(_, opts)
		require("multiple-cursors").setup(opts)

		local function rescue()
			local ok, mc = pcall(require, "multiple-cursors")
			if ok then
				pcall(mc.deinit, true)
			end
			local ok_km, km = pcall(require, "multiple-cursors.key_maps")
			if ok_km then
				pcall(km.delete)
				pcall(km.restore_existing)
			end
			vim.notify("multiple-cursors: keymaps restored", vim.log.levels.INFO)
		end

		vim.api.nvim_create_user_command("MultipleCursorsReset", rescue, {
			desc = "Force-restore keymaps after multiple-cursors exits badly",
		})
		vim.keymap.set("n", "<C-c>", rescue, { desc = "Reset multiple-cursors keymaps" })
	end,
	keys = {
		{ "<C-l>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" }, desc = "Add cursor up" },
		{ "<C-u>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" }, desc = "Add cursor down" },
		{
			"<Leader>ml",
			"<Cmd>MultipleCursorsAddUp<CR>",
			mode = { "n" },
			desc = "Add cursor up (Ctrl-l normally)",
		},
		{
			"<Leader>mu",
			"<Cmd>MultipleCursorsAddDown<CR>",
			mode = { "n" },
			desc = "Add cursor down (-u normally)",
		},

		{
			"<Leader>ma",
			"<Cmd>MultipleCursorsAddMatches<CR>",
			mode = { "n", "v" },
			desc = "Add all matches under cursor",
		},
		{
			"<Leader>md",
			"<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
			mode = { "n", "v" },
			desc = "Add match under cursor and jump to next",
		},
	},
}

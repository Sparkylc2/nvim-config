-- snacks.picker, replacing telescope + telescope-fzf-native + telescope-ui-select
-- + telescope-symbols (4 plugins).
--
-- Removing telescope also removes one of the two things blocking the
-- nvim-treesitter main-branch migration: telescope's __files.lua requires
-- nvim-treesitter.locals, which does not exist on main.
--
-- GAP: <leader>fm was telescope-symbols' LaTeX symbol browser. snacks has no
-- equivalent (its `icons` source is nerd-font/emoji only). cmp-omni is already
-- wired for tex, so symbol *insertion* still works via completion -- but the
-- browse-and-pick UI is gone. Left unmapped rather than silently rebound.

return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				enabled = true,

				-- replaces telescope-ui-select: vim.ui.select now renders here,
				-- which is also what makes YankyRingHistory and :AutoSession
				-- search look consistent with everything else
				ui_select = true,

				-- no dimming behind the picker: the float should read as part of
				-- the editor, not as an overlay on top of it
				layout = { backdrop = false },

				win = {
					input = {
						keys = {
							-- match the fzf popups in tmux and the cmp menu:
							-- Colemak home row, plus the telescope-era C-j/C-k
							["<A-e>"] = { "list_down", mode = { "i", "n" } },
							["<A-i>"] = { "list_up", mode = { "i", "n" } },
							["<C-j>"] = { "list_down", mode = { "i", "n" } },
							["<C-k>"] = { "list_up", mode = { "i", "n" } },
							["<C-q>"] = { "qflist", mode = { "i", "n" } },
						},
					},
				},
			},
		},

		keys = {
			-- same <leader>f* namespace the telescope bindings used
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Grep current word",
				mode = { "n", "x" },
			},
			{
				"<leader>fd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fs",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"<leader>fS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "Workspace symbols",
			},

			-- things telescope never gave you
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			{
				"<leader>fu",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo history",
			},
			{
				"<leader>f'",
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>fR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume last picker",
			},
			{
				"<leader>fG",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git status",
			},
		},
	},
}

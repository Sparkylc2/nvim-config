-- snacks.nvim, batch 1.
--
-- Replaces: alpha-nvim (dashboard), indent-blankline (indent), zen-mode (zen),
-- peepsight (dim), kdheepak/lazygit.nvim (lazygit).
-- Adds: bigfile, scroll, input, notifier.
--
-- The picker is deliberately NOT enabled yet -- telescope stays until that swap
-- gets its own branch, so the dashboard buttons below still call Telescope.

local header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡆⠀⢀⡀⣀⢀⡀⠀⠀⣀⢀⡀⣀⠀⢠⣿⣿⠏⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠯⠥⠤⢤⣉⣉⡉⠉⠉⠉⢩⣿⣿⣿⣾⠁⠀⠘⠿⣿⣷⣿⡇⠈⢀⣠⣽⣯⡸⣿⣿⣭⣳⠀⣀⣠⡤⠭⠟⠛⠛⠃⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣀⣤⡤⠴⣶⠶⣶⠶⠟⢛⣒⠿⠿⠿⠿⠿⠿⢿⣏⠙⠒⠒⠒⠒⠒⢹⡿⢛⣉⡄⠀⠀⠀⠀⢾⣿⣿⣷⡆⠀⠈⠏⣿⣿⣿⣿⡛⠟⡿⠿⠿⠿⠿⠿⣿⣿⣯⠀⠉⠉⡟⣽⢿⣿⠷⣾⣶⣶⣤⡤⣄⠀
⣯⣆⣤⣤⣴⠦⢤⣤⣤⣄⣉⠁⠈⠉⠉⠉⠒⠉⠁⠀⠀⠀⠀⢐⣀⢼⡿⢭⡇⠀⠀⣀⣠⣴⡿⢇⢈⣿⣿⣦⣄⣐⣤⣹⣿⣿⣿⣤⣿⡀⣀⡀⠀⠀⢀⣀⣀⣠⣤⣤⠤⢤⣴⣶⣿⣿⡿⠿⠿⠿⠛⠂
⠀⠀⠈⠋⠉⠙⠓⠒⠒⠒⠒⠛⠿⠷⠴⠤⠤⠤⠆⠠⠤⣄⣶⣤⡤⠌⠐⠋⠀⠐⠁⢸⣾⣿⣿⡿⢺⣿⣿⣿⣿⣧⣭⣛⣯⣽⣿⡷⣾⠿⠿⠿⠯⠭⠿⠗⠒⠚⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⡇⠀⡤⠚⠁⢰⣾⣿⣼⣾⣇⢸⣿⣿⣿⣿⣿⣯⡏⢿⣿⠻⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢴⣦⣤⣤⣭⣧⡟⡟⠻⡿⡟⢻⣿⣿⣿⣿⣿⣿⣯⣭⣭⣭⡿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣧⢀⠀⠀⠀⠀⠉⢹⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣮⠀⣢⠔⠊⡑⢸⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⣁⣤⡘⢇⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠷⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- turns off treesitter/LSP/syntax on huge files, which is what
			-- synmaxcol and the 1000-line branch in clangd's on_attach were
			-- crudely approximating
			bigfile = { enabled = true },

			-- replaces alpha-nvim
			dashboard = {
				enabled = true,
				preset = {
					header = header,
					-- still Telescope: the picker swap is a later batch
					keys = {
						{ icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
						{ icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
						{ icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
						{ icon = " ", key = "t", desc = "Find text", action = ":Telescope live_grep" },
						{ icon = " ", key = "s", desc = "Restore session", action = ":AutoSession restore" },
						{
							icon = " ",
							key = "c",
							desc = "Configuration",
							action = ":e ~/.config/nvim/init.lua",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ text = "Flight dynamics will be the death of me", hl = "Type", align = "center" },
				},
			},

			-- replaces peepsight. Scope-based rather than peepsight's explicit
			-- treesitter node list, so it needs no per-language configuration --
			-- and, unlike peepsight, no nvim-treesitter.ts_utils, which is one of
			-- the two things blocking the treesitter main-branch migration.
			dim = { enabled = true },

			-- replaces indent-blankline
			indent = {
				enabled = true,
				indent = { char = "│" },
				scope = { enabled = false },
			},

			input = { enabled = true },

			-- replaces kdheepak/lazygit.nvim
			lazygit = { enabled = true },

			notifier = { enabled = true, timeout = 3000 },

			scratch = { enabled = true },

			scroll = { enabled = true },

			-- ]] / [[ jump between LSP references of the symbol under the cursor
			words = { enabled = true },

			-- replaces zen-mode.nvim
			zen = {
				enabled = true,
				toggles = { dim = true, git_signs = false },
				win = { width = 120 },
			},

			styles = {
				zen = {
					backdrop = { transparent = false },
				},
			},
		},

		keys = {
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Zen mode",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "LazyGit log",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Scratch buffer",
			},
			-- NOT <leader>S: that is the session-management prefix
			{
				"<leader>,",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select scratch buffer",
			},
			{
				"]]",
				function()
					Snacks.words.jump(1)
				end,
				desc = "Next reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-1)
				end,
				desc = "Prev reference",
			},
		},

		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- replaces the hand-rolled inlay-hints toggle in lsp/ui.lua
					Snacks.toggle.dim():map("<leader>p")
					Snacks.toggle.inlay_hints():map("<leader>ih")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle.treesitter():map("<leader>uT")
				end,
			})
		end,
	},
}

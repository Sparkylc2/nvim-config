-- snacks.nvim, batch 1.
--
-- Replaces: alpha-nvim (dashboard), indent-blankline (indent),
-- peepsight (dim), kdheepak/lazygit.nvim (lazygit).
-- zen-mode.nvim is deliberately KEPT: it drives kitty font + tmux status,
-- which snacks.zen does not. See lua/plugins/editor/zen.lua.
-- Adds: bigfile, scroll, input, notifier.
--
-- The picker lives in lua/plugins/editor/picker.lua.

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
					keys = {
						{ icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
						{ icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
						{ icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
						{ icon = " ", key = "t", desc = "Find text", action = ":lua Snacks.picker.grep()" },
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

			-- no dimming behind any snacks float -- lazygit, terminal, zen and
			-- the picker should all read as part of the editor, not as overlays
			styles = {
				lazygit = { backdrop = false },
				terminal = { backdrop = false },
				float = { backdrop = false },
				notification = { backdrop = false },
			},

			notifier = { enabled = true, timeout = 3000 },

			-- inline images in the buffer, and rendered LaTeX math. Needs a
			-- graphics-capable terminal -- kitty qualifies.
			image = { enabled = true },

			-- LSP-aware file rename: renaming a file tells the language servers so
			-- imports/includes follow. Wired to oil below.
			rename = { enabled = true },

			scratch = { enabled = true },

			-- defaults are step=10/total=200 (and 5/50 when repeating), which
			-- reads as lag. Roughly halved, with a snappier repeat so held
			-- <C-d>/<C-u> keeps up instead of queueing behind the animation.
			scroll = {
				enabled = true,
				animate = {
					duration = { step = 5, total = 30 },
					-- easing = "inOutSine",
					easing = "linear",
				},
				animate_repeat = {
					delay = 20,
					duration = { step = 3, total = 25 },
					easing = "linear",
				},
			},

			-- ]] / [[ jump between LSP references of the symbol under the cursor
			words = { enabled = true },
		},

		keys = {
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
			-- tell the LSPs about oil renames so imports/includes follow.
			-- This is the general version of what lua/tools/cpp/include_rename.lua
			-- does by hand for C/C++ headers.
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data and event.data.actions then
						for _, a in ipairs(event.data.actions) do
							if a.type == "move" then
								Snacks.rename.on_rename_file(a.src_url, a.dest_url)
							end
						end
					end
				end,
			})

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

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"OXY2DEV/markview.nvim",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"regex",
					"scss",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
					"matlab",
				},
				highlight = {
					enable = true,
					disable = { "latex" },
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = { "vue" },
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ua"] = "@parameter.inner",

							["af"] = "@function.outer",
							["uf"] = "@function.inner",

							["ac"] = "@class.outer",
							["uc"] = "@class.inner",

							["ai"] = "@conditional.outer",
							["ui"] = "@conditional.inner",

							["al"] = "@loop.outer",
							["ul"] = "@loop.inner",

							["aC"] = "@comment.outer",
							["uC"] = "@comment.inner",

							["ab"] = "@block.outer",
							["ub"] = "@block.inner",

							["as"] = "@statement.outer",

							["am"] = "@call.outer",
							["um"] = "@call.inner",

							["ar"] = "@return.outer",
							["ur"] = "@return.inner",

							["a="] = "@assignment.outer",
							["u="] = "@assignment.inner",
							["av"] = "@assignment.lhs",
							["uv"] = "@assignment.rhs",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.inner",
							["]i"] = "@conditional.outer",
							["]l"] = "@loop.outer",
							["]C"] = "@comment.outer",
							["]b"] = "@block.outer",
							["]m"] = "@call.outer",
							["]r"] = "@return.outer",
							["]="] = "@assignment.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]A"] = "@parameter.inner",
							["]I"] = "@conditional.outer",
							["]L"] = "@loop.outer",
							["]B"] = "@block.outer",
							["]M"] = "@call.outer",
							["]R"] = "@return.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.inner",
							["[i"] = "@conditional.outer",
							["[l"] = "@loop.outer",
							["[C"] = "@comment.outer",
							["[b"] = "@block.outer",
							["[m"] = "@call.outer",
							["[r"] = "@return.outer",
							["[="] = "@assignment.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[A"] = "@parameter.inner",
							["[I"] = "@conditional.outer",
							["[L"] = "@loop.outer",
							["[B"] = "@block.outer",
							["[M"] = "@call.outer",
							["[R"] = "@return.outer",
						},

						goto_next = {
							["]s"] = "@statement.outer",
						},
						goto_previous = {
							["[s"] = "@statement.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = "@parameter.inner",
							["<leader>sf"] = "@function.outer",
							["<leader>sL"] = "@statement.outer",
						},
						swap_previous = {
							["<leader>sA"] = "@parameter.inner",
							["<leader>sF"] = "@function.outer",
							["<leader>sL"] = "@statement.outer",
						},
					},
					lsp_interop = {
						enable = true,
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>df"] = "@function.outer",
							["<leader>dc"] = "@class.outer",
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		end,
	},
}

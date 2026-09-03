local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"html",
	"javascript",
	"json",
	"lua",
	"latex",
	"markdown",
	"matlab",
	"python",
	"query",
	"regex",
	"scss",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
}

local highlight_filetypes = {
	"bash",
	"c",
	"cpp",
	"css",
	"help",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"matlab",
	"python",
	"scss",
	"typescript",
	"typescriptreact",
	"vim",
	"vue",
	"yaml",
}

local indent_filetypes = {
	"bash",
	"c",
	"cpp",
	"css",
	"help",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"matlab",
	"python",
	"scss",
	"tex",
	"typescript",
	"typescriptreact",
	"vim",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install(parsers)

			vim.treesitter.language.register("latex", "tex")
			vim.treesitter.language.register("tsx", "typescriptreact")
			vim.treesitter.language.register("bash", "sh")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = highlight_filetypes,
				callback = function()
					vim.treesitter.start()
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = indent_filetypes,
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
		init = function()
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

			local function select_map(lhs, query_string)
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query_string, "textobjects")
				end)
			end

			select_map("aa", "@parameter.outer")
			select_map("ua", "@parameter.inner")

			select_map("af", "@function.outer")
			select_map("if", "@function.inner")

			select_map("ac", "@class.outer")
			select_map("ic", "@class.inner")

			select_map("ai", "@conditional.outer")
			select_map("ii", "@conditional.inner")

			select_map("al", "@loop.outer")
			select_map("il", "@loop.inner")

			select_map("aC", "@comment.outer")
			select_map("iC", "@comment.inner")

			select_map("ab", "@block.outer")
			select_map("ib", "@block.inner")

			select_map("as", "@statement.outer")

			select_map("am", "@call.outer")
			select_map("im", "@call.inner")

			select_map("ar", "@return.outer")
			select_map("ir", "@return.inner")

			select_map("a=", "@assignment.outer")
			select_map("i=", "@assignment.inner")
			select_map("av", "@assignment.lhs")
			select_map("iv", "@assignment.rhs")

			local function move_map(lhs, fn, query_string)
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					fn(query_string, "textobjects")
				end)
			end

			move_map("]f", move.goto_next_start, "@function.outer")
			move_map("]c", move.goto_next_start, "@class.outer")
			move_map("]a", move.goto_next_start, "@parameter.inner")
			move_map("]i", move.goto_next_start, "@conditional.outer")
			move_map("]l", move.goto_next_start, "@loop.outer")
			move_map("]C", move.goto_next_start, "@comment.outer")
			move_map("]b", move.goto_next_start, "@block.outer")
			move_map("]m", move.goto_next_start, "@call.outer")
			move_map("]r", move.goto_next_start, "@return.outer")
			move_map("]=", move.goto_next_start, "@assignment.outer")

			move_map("]F", move.goto_next_end, "@function.outer")
			move_map("]A", move.goto_next_end, "@parameter.inner")
			move_map("]I", move.goto_next_end, "@conditional.outer")
			move_map("]L", move.goto_next_end, "@loop.outer")
			move_map("]B", move.goto_next_end, "@block.outer")
			move_map("]M", move.goto_next_end, "@call.outer")
			move_map("]R", move.goto_next_end, "@return.outer")

			move_map("[f", move.goto_previous_start, "@function.outer")
			move_map("[c", move.goto_previous_start, "@class.outer")
			move_map("[a", move.goto_previous_start, "@parameter.inner")
			move_map("[i", move.goto_previous_start, "@conditional.outer")
			move_map("[l", move.goto_previous_start, "@loop.outer")
			move_map("[C", move.goto_previous_start, "@comment.outer")
			move_map("[b", move.goto_previous_start, "@block.outer")
			move_map("[m", move.goto_previous_start, "@call.outer")
			move_map("[r", move.goto_previous_start, "@return.outer")
			move_map("[=", move.goto_previous_start, "@assignment.outer")

			move_map("[F", move.goto_previous_end, "@function.outer")
			move_map("[A", move.goto_previous_end, "@parameter.inner")
			move_map("[I", move.goto_previous_end, "@conditional.outer")
			move_map("[L", move.goto_previous_end, "@loop.outer")
			move_map("[B", move.goto_previous_end, "@block.outer")
			move_map("[M", move.goto_previous_end, "@call.outer")
			move_map("[R", move.goto_previous_end, "@return.outer")

			move_map("]s", move.goto_next, "@statement.outer")
			move_map("[s", move.goto_previous, "@statement.outer")

			vim.keymap.set("n", "<leader>sa", function()
				swap.swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>sf", function()
				swap.swap_next("@function.outer")
			end)
			vim.keymap.set("n", "<leader>sL", function()
				swap.swap_next("@statement.outer")
			end)

			vim.keymap.set("n", "<leader>sA", function()
				swap.swap_previous("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>sF", function()
				swap.swap_previous("@function.outer")
			end)
			vim.keymap.set("n", "<leader>sL", function()
				swap.swap_previous("@statement.outer")
			end)

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		end,
	},
}

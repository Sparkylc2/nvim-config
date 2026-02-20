return {
	"koenverburg/peepsight.nvim",
	event = "VeryLazy",
	config = function()
		require("peepsight").setup({
			-- ts/js
			"class_declaration",
			"method_definition",
			"arrow_function",
			"function_declaration",
			"generator_function_declaration",
			-- cpp lua etc
			"function_definition",
			"function_declaration",
			-- rust
			"function_item",
			-- latex
			"generic_environment",
			"math_environment",
			"displayed_equation",
			"inline_formula",
			"text_mode",
			"section",
			"subsection",
			"subsubsection",
			"item",
			"enum_item",
			"generic_command",
			"curly_group",
			"brack_group",
		})

		-- vim.api.nvim_set_hl(0, "PeepsightDim", {
		-- 	fg = "#555555",
		-- })

		vim.keymap.set("n", "<leader>p", function()
			require("peepsight").toggle()
		end, { desc = " Peepsight Toggle" })
	end,
}

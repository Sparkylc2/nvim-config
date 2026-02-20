return {
	{
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
			},
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			-- latex autopair rules
			npairs.add_rules({
				Rule("\\(", "\\)", "tex"),
				Rule("\\[", "\\]", "tex"),
				Rule("\\{", "\\}", "tex"),
				Rule("\\langle", "\\rangle", "tex"),
				Rule("\\lfloor", "\\rfloor", "tex"),
				Rule("\\lceil", "\\rceil", "tex"),
				Rule("\\lvert", "\\rvert", "tex"),
				Rule("\\lVert", "\\rVert", "tex"),
				Rule("_", "{}", "tex"):set_end_pair_length(1):with_pair(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					return line:sub(col + 1, col + 1) ~= "{"
				end),
				Rule("^", "{}", "tex"):set_end_pair_length(1):with_pair(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					return line:sub(col + 1, col + 1) ~= "{"
				end),

				Rule("$", "$", "tex"):with_pair(cond.not_before_regex("\\", 1)), -- $ pair (not when escaped)
			})
		end,
	},
}

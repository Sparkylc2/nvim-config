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
			})
			-- $ pair (not when escaped)
			npairs.add_rule(Rule("$", "$", "tex"):with_pair(cond.not_before_regex("\\", 1)))
		end,
	},
}

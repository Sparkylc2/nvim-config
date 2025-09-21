return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			surrounds = {
				e = {
					add = function()
						local env = require("nvim-surround.config").get_input("Environment: ")
						return {
							{ "\\begin{" .. env .. "}" },
							{ "\\end{" .. env .. "}" },
						}
					end,
					find = "\\begin{.+}.-\\end{.+}",
					delete = "^(\\begin{.+})().-(\\end{.+})()$",
					change = {
						target = "^\\begin{(.+)}.-\\end{(.+)}$",
						replacement = function()
							local env = require("nvim-surround.config").get_input("Environment: ")
							return {
								{ "\\begin{" .. env .. "}" },
								{ "\\end{" .. env .. "}" },
							}
						end,
					},
				},
			},
		})
	end,
	keys = {
		{ "ysie", "ysi<C-r>=GetMotionCount()<CR>e", desc = "Surround with LaTeX environment", ft = "tex" },
		{ "cse", "cs e", desc = "Change surrounding LaTeX environment", ft = "tex" },
		{ "dse", "ds e", desc = "Delete surrounding LaTeX environment", ft = "tex" },
	},
}

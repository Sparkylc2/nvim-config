return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local p = require("config.palette")
			local function outlined(fg)
				return { fg = fg, bg = p.bg }
			end

			local theme = {}
			for mode, accent in pairs({
				normal = p.blue,
				insert = p.green,
				visual = p.magenta,
				replace = p.red,
				command = p.yellow,
				inactive = p.gray,
			}) do
				theme[mode] = {
					a = outlined(accent),
					b = outlined(p.fg),
					c = outlined(p.fg),
					x = outlined(p.fg),
					y = outlined(p.fg_dim),
					z = outlined(accent),
				}
			end

			require("lualine").setup({
				options = {
					theme = theme,
					globalstatus = true,
					section_separators = "",
					component_separators = "",
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s)
								return "" .. s:sub(1, 1) .. ""
							end,
						},
					},
					lualine_b = {
						{
							"branch",
							fmt = function(s)
								return s ~= "" and ("" .. s .. "") or ""
							end,
						},
						"diff",
					},
					lualine_c = { { "filename", path = 0 } },
					lualine_x = { "diagnostics", "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = {
						{
							"location",
							fmt = function(s)
								return "" .. s .. ""
							end,
						},
					},
				},
			})
		end,
	},
}

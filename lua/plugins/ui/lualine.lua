return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local p = require("config.palette")

			-- Outlined rather than filled: every section sits on the editor
			-- background and is capped with rounded glyphs in the section's accent
			-- colour, so the statusline reads as part of the buffer.
			--
			-- The caps are baked into the component text with `fmt` rather than
			-- set via `section_separators`. That is deliberate: lualine draws a
			-- separator as (fg = this section's bg, bg = next section's bg), and
			-- since every section here shares the editor background the glyphs
			-- came out background-on-background, i.e. invisible. Inside the
			-- component they inherit the component's fg, which is the accent.
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
					b = outlined(p.fg_dim),
					c = outlined(p.gray),
					x = outlined(p.gray),
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

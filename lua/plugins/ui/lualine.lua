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

			-- word count of the visual selection, prose filetypes only
			local prose = { text = true, markdown = true, tex = true, plaintex = true }
			local function selection_words()
				return vim.fn.wordcount().visual_words .. "w"
			end
			local function in_prose_selection()
				return prose[vim.bo.filetype] and vim.fn.mode():find("^[vV\22]") ~= nil
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
						{ selection_words, cond = in_prose_selection },
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

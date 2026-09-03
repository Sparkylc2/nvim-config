local M = {}

M.bg = "#181616" -- dragonBlack3, the editor background
M.bg_dark = "#0d0c0c" -- dragonBlack0, darker floats
M.bg_light = "#282727" -- dragonBlack5, pmenu / raised surfaces
M.fg = "#c5c9c5" -- dragonWhite
M.fg_dim = "#a6a69c" -- dragonGray
M.gray = "#625e5a" -- line numbers, inactive text
M.border = "#54546D" -- float borders
M.red = "#c4746e" -- dragonRed
M.green = "#8a9a7b" -- dragonGreen
M.yellow = "#c4b28a" -- dragonYellow
M.blue = "#8ba4b0" -- dragonBlue
M.magenta = "#a292a3" -- dragonPink
M.cyan = "#8ea4a2" -- dragonAqua
M.orange = "#b6927b" -- dragonOrange
M.teal = "#8ea4a2" -- alias of cyan; kept because the cmp block used both names
M.white = "#C8C093" -- oldWhite

M.error = "#e46876" -- dragonRed, brightened
M.warn = "#dca561" -- dragonOrange/yellow, brightened
M.info = "#7fb4ca" -- dragonBlue, brightened
M.hint = "#9fc6a0" -- dragonGreen, brightened
M.ok = M.hint

M.yank_bg = "#2d4f67"

---Mix two "#rrggbb" strings. t=0 returns a, t=1 returns b.
---@param a string
---@param b string
---@param t number
---@return string
function M.blend(a, b, t)
	local function rgb(hex)
		return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
	end
	local ar, ag, ab = rgb(a)
	local br, bg, bb = rgb(b)
	return string.format(
		"#%02x%02x%02x",
		math.floor(ar + (br - ar) * t + 0.5),
		math.floor(ag + (bg - ag) * t + 0.5),
		math.floor(ab + (bb - ab) * t + 0.5)
	)
end

---Apply a table of { GroupName = { ... } } highlight definitions.
---@param groups table<string, table>
function M.apply(groups)
	for name, spec in pairs(groups) do
		vim.api.nvim_set_hl(0, name, spec)
	end
end

return M

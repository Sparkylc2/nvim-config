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

-- Diagnostic accents, as used by the sign column
M.error = "#FF5D62"
M.warn = M.yellow
M.info = "#7FB4CA"
M.hint = M.green

---Apply a table of { GroupName = { ... } } highlight definitions.
---@param groups table<string, table>
function M.apply(groups)
	for name, spec in pairs(groups) do
		vim.api.nvim_set_hl(0, name, spec)
	end
end

-- Mirrored by hand elsewhere:
--   tmux/tmux.conf      bg fg black red green yellow blue magenta cyan white gray
--   aerospace.toml      borders active/inactive/background = 0xff181616

return M

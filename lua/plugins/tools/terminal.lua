-- snacks.terminal, replacing toggleterm.nvim.
--
-- snacks keys terminals by their command + cwd rather than by numeric id, so
-- Snacks.terminal.toggle(nil, { cwd = X }) reuses the same window for the same
-- directory. That is what makes the "cwd of buffer" variants below work without
-- tracking ids by hand.
--
-- Terminal-mode keymaps still live in lua/config/autocmds.lua (TermTweaks).
-- Do not re-map <A-n/e/i/o> here: raw escape sequences like "\x1b[A" are fed one
-- keystroke at a time, so the shell can receive a lone ESC before "[A" lands. In
-- nushell's vi edit_mode that drops you into vi-normal and eats the rest as
-- commands. <Up>/<Down>/... are encoded by nvim's terminal in a single write and
-- honour DECCKM.

local function buf_dir()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return vim.fn.getcwd()
	end
	return vim.fn.fnamemodify(path, ":p:h")
end

---@param win_opts table
local function term(win_opts, opts)
	opts = vim.tbl_deep_extend("force", { win = win_opts }, opts or {})
	return function()
		Snacks.terminal.toggle(nil, opts)
	end
end

local float = { position = "float", border = "rounded" }
local horiz = { position = "bottom", height = 0.3 }
local vert = { position = "right", width = 0.4 }

return {
	{
		"folke/snacks.nvim",
		opts = {
			terminal = {
				win = {
					position = "float",
					border = "rounded",
					-- Float-only keys. The shared terminal scheme (<Esc> to the
					-- shell, <C-e>/<A-Esc> to nvim normal mode, <A-neio> window
					-- navigation) lives in the TermOpen autocmd in
					-- lua/config/autocmds.lua, which fires for these buffers too
					-- -- snacks terminals are ordinary terminal buffers.
					keys = {
						-- dismiss the float without killing the shell
						term_hide = {
							"<A-.>",
							function(self)
								self:hide()
							end,
							mode = { "n", "t" },
							desc = "Hide terminal",
						},
						-- in nvim-normal mode over the terminal, q closes it.
						-- Safe here because normal mode is not typed text --
						-- nvim's own mode IS knowable, unlike the shell's.
						q = "close",
					},
				},
			},
		},
		keys = {
			{ "<leader>tf", term(float), desc = "Float terminal" },
			{ "<leader>th", term(horiz), desc = "Horizontal terminal" },
			{ "<leader>tv", term(vert), desc = "Vertical terminal" },

			-- same three, rooted at the current buffer's directory
			{
				"<leader>tcf",
				function()
					Snacks.terminal.toggle(nil, { cwd = buf_dir(), win = float })
				end,
				desc = "Float terminal (cwd of buffer)",
			},
			{
				"<leader>tch",
				function()
					Snacks.terminal.toggle(nil, { cwd = buf_dir(), win = horiz })
				end,
				desc = "Horizontal terminal (cwd of buffer)",
			},
			{
				"<leader>tcv",
				function()
					Snacks.terminal.toggle(nil, { cwd = buf_dir(), win = vert })
				end,
				desc = "Vertical terminal (cwd of buffer)",
			},

			-- toggleterm's open_mapping
			{
				"<C-\\>",
				function()
					Snacks.terminal.toggle()
				end,
				mode = { "n", "t" },
				desc = "Toggle terminal",
			},
		},
	},
}

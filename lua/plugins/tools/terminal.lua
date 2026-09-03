-- snacks.terminal, replacing toggleterm.nvim.
--
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

local top_only = { "─", "", "", "", "", "", "", "" }

local float = { position = "float", border = "rounded" }
local no_winbar = { winbar = "" }

local horiz = { position = "bottom", height = 0.3, border = top_only, wo = no_winbar }
local vert = { position = "right", width = 0.4, border = top_only, wo = no_winbar }

return {
	{
		"folke/snacks.nvim",
		opts = {
			terminal = {
				win = {
					position = "float",
					border = "rounded",
					wo = { winbar = "" },
					keys = {
						term_hide = {
							"<A-.>",
							function(self)
								self:hide()
							end,
							mode = { "n", "t" },
							desc = "Hide terminal",
						},
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

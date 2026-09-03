local toggle_key = "<M-.>"
local model_args = "--model sonnet"

local function claude_term()
	local ok, term = pcall(require, "claudecode.terminal")
	if not ok then
		return nil, nil
	end
	return term, term.get_active_terminal_bufnr()
end

-- ctrl-L clears the TUI's screen; the width nudge fires SIGWINCH so it repaints from scratch
local function soft_reset()
	local term, buf = claude_term()
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("Claude terminal is not running", vim.log.levels.WARN)
		return
	end
	term.send_to_terminal("\12", { submit = false })

	local win = vim.fn.win_findbuf(buf)[1]
	if not win then
		vim.cmd("redraw!")
		return
	end

	local width = vim.api.nvim_win_get_width(win)
	vim.api.nvim_win_set_width(win, width - 1)
	vim.schedule(function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_width(win, width)
		end
		vim.cmd("redraw!")
	end)
end

-- kills the pty and reopens with --continue, so the conversation survives
local function hard_reset()
	local term, buf = claude_term()
	if term then
		term.close()
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end

	vim.defer_fn(function()
		vim.cmd("ClaudeCodeOpen --continue " .. model_args)
	end, 250)
end

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		focus_after_send = true,
		terminal = {
			split_side = "right",
			split_width_percentage = 0.4,
			snacks_win_opts = {
				keys = {
					claude_hide = {
						toggle_key,
						function(self)
							self:hide()
						end,
						mode = "t",
						desc = "Hide Claude",
					},
					nav_left = {
						"<A-n>",
						function()
							require("smart-splits").move_cursor_left()
						end,
						mode = "t",
						desc = "Split left",
					},
					nav_down = {
						"<A-e>",
						function()
							require("smart-splits").move_cursor_down()
						end,
						mode = "t",
						desc = "Split down",
					},
					nav_up = {
						"<A-i>",
						function()
							require("smart-splits").move_cursor_up()
						end,
						mode = "t",
						desc = "Split up",
					},
					nav_right = {
						"<A-o>",
						function()
							require("smart-splits").move_cursor_right()
						end,
						mode = "t",
						desc = "Split right",
					},
				},
			},
		},
	},
	keys = {
		{ toggle_key, "<cmd>ClaudeCodeFocus --model sonnet<cr>", mode = { "n", "x", "t" }, desc = "Claude (Sonnet)" },
		{ "<leader>cc", "<cmd>ClaudeCode --model sonnet<cr>", desc = "Toggle Claude" },
		{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>cs",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		{ "<leader>cx", soft_reset, desc = "Claude: repaint window" },
		{ "<leader>cX", hard_reset, desc = "Claude: restart (keeps conversation)" },
	},
}

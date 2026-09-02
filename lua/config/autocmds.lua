-- ==== groups ================================================================
local aug = vim.api.nvim_create_augroup

local fast_ui = aug("FastUI", { clear = true })
local yank_grp = aug("YankHighlight", { clear = true })
local ft_group = aug("FileTypeSettings", { clear = true })
local term_group = aug("TermTweaks", { clear = true })
local open_ext = aug("ExternalOpeners", { clear = true })
local quit_grp = aug("QuitHooks", { clear = true })
local perf_guard = aug("PerfGuard", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_grp,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

local ft_handlers = {
	javascript = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
	typescript = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
	javascriptreact = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
	typescriptreact = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
	vue = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
	python = function()
		vim.opt_local.colorcolumn = "88"
	end,
	c = function()
		vim.opt_local.commentstring = "// %s"
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
	cpp = function()
		vim.opt_local.commentstring = "// %s"
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
	markdown = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
}

-- filetype settings
vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = "*",
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local f = ft_handlers[ft]
		if f then
			pcall(f)
		end
	end,
})

-- terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = term_group,
	callback = function(event)
		vim.opt_local.buflisted = false
		vim.opt_local.modifiable = false

		-- claude code binds esc, alt+o etc itself; shadowing them breaks its TUI
		if vim.api.nvim_buf_get_name(event.buf):lower():find("claude", 1, true) then
			return
		end

		local opts = { buffer = event.buf }

		-- <Esc> goes to the SHELL, not to nvim: nushell's vi edit_mode, fzf,
		-- lazygit and REPLs all need it, and losing it makes editing a command
		-- line painful. Swapped from the other way round.
		vim.keymap.set("t", "<esc>", "<esc>", opts)
		-- ...so leaving terminal mode needs its own keys. <C-e> and <A-Esc> both
		-- drop to nvim normal mode for scrollback, search and yank; i/a/A returns.
		-- <C-\><C-n> is nvim's built-in and always works as a fallback.
		vim.keymap.set("t", "<C-e>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<A-esc>", [[<C-\><C-n>]], opts)
		-- Send real cursor keys, not raw "\x1b[A" byte strings: nvim encodes these
		-- in one write and respects the app's cursor-key mode.
		vim.keymap.set("t", "<A-n>", "<Left>", opts) -- left
		vim.keymap.set("t", "<A-o>", "<Right>", opts) -- right
		vim.keymap.set("t", "<A-i>", "<Up>", opts) -- up
		vim.keymap.set("t", "<A-e>", "<Down>", opts) -- down

		-- Window navigation without leaving terminal mode. Alt+Shift, because
		-- plain A-neio are the cursor keys above and capital NEIO in terminal
		-- mode are just typed text.
		local function nav(fn)
			return function()
				require("smart-splits")[fn]()
			end
		end
		vim.keymap.set("t", "<A-N>", nav("move_cursor_left"), opts)
		vim.keymap.set("t", "<A-E>", nav("move_cursor_down"), opts)
		vim.keymap.set("t", "<A-I>", nav("move_cursor_up"), opts)
		vim.keymap.set("t", "<A-O>", nav("move_cursor_right"), opts)
	end,
})

-- open pdfs in skim
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = open_ext,
	pattern = "*.pdf",
	callback = function()
		local cmd = "arview " .. ("--ppid %d "):format(vim.fn.getpid()) .. '"' .. vim.api.nvim_buf_get_name(0) .. '"'
		vim.fn.jobstart(cmd, { detach = true })
		vim.cmd("bd!")
	end,
})

-- close pdfs
vim.api.nvim_create_autocmd("BufEnter", {
	group = open_ext,
	pattern = "*.pdf",
	callback = function()
		vim.bo.bufhidden = "wipe"
		vim.keymap.set("n", "q", function()
			local win_count = #vim.api.nvim_list_wins()
			if win_count == 1 then
				vim.cmd("enew")
				vim.cmd("bd#")
			else
				vim.cmd("bd")
			end
		end, { buffer = true, desc = "Close PDF buffer safely" })
	end,
})

-- open images
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = open_ext,
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	callback = function()
		local img_path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "open", img_path }, { detach = true })
		vim.cmd("bd!")
	end,
})

-- quit terminal correctly
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = quit_grp,
	callback = function()
		local cmd = vim.fn.getcmdline()
		if cmd == "wqa" or cmd == "wqa!" or cmd == "qa" then
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local chan = vim.bo[buf].channel
					if chan and chan > 0 then
						pcall(vim.fn.jobstop, chan)
					end
				end
			end
		end
	end,
})
-- launches neovim cd'd into the working directory it was launched as an arg with
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "cd to passed $PWD when vim starts.",
	group = vim.api.nvim_create_augroup("cd-to-pwd", { clear = true }),
	callback = function()
		local pwd = vim.fn.getcwd()
		vim.api.nvim_set_current_dir(pwd)
	end,
})

-- run npm tasks easily
vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = {
		"json",
		"markdown",
		"js",
		"css",
		"html",
	},
	callback = function()
		vim.keymap.set("n", "<leader>npm", ":!npm run dev<CR>", { buffer = true, desc = "Run npm dev" })
	end,
})

-- open markdown preview in arview
vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = { "markdown", "md", "rmd", "quarto" },
	callback = function()
		vim.keymap.set("n", "<leader>lv", function()
			local cmd = "arview "
				.. ("--ppid %d "):format(vim.fn.getpid())
				.. '"'
				.. vim.api.nvim_buf_get_name(0)
				.. '"'
			vim.fn.jobstart(cmd, { detach = true })
		end, { desc = "Open markdown preview in arview", buffer = true })
	end,
})

-- run make and the output of that
vim.api.nvim_create_autocmd("FileType", {
	group = ft_group,
	pattern = { "c", "cpp" },
	callback = function()
		vim.keymap.set("n", "<leader>rm", ":!make<CR>", { buffer = true, desc = "Run make run" })
		vim.keymap.set("n", "<leader>rf", ":!./a.out<CR>", { buffer = true, desc = "Run make output" })
	end,
})

-- disable inline lsp hints
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		pcall(function()
-- 			vim.lsp.inlay_hint.enable(args.buf, false)
-- 		end)
-- 	end,
-- })

-- toggle inlay hints (doesn't seem to work)
vim.keymap.set("n", "<leader>ih", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok_is_enabled, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
	if not ok_is_enabled then
		is_enabled = false
	end
	pcall(vim.lsp.inlay_hint.enable, bufnr, not is_enabled)
end, { desc = "Toggle Inlay Hints" })

-- run the current python file
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.keymap.set("n", "<leader>rp", function()
			local file = vim.fn.expand("%:p")
			if file == nil or file == "" then
				vim.notify("No file to run", vim.log.levels.WARN)
				return
			end
			local cmd = "python3 " .. vim.fn.shellescape(file)
			require("toggleterm").exec(cmd, 1, 12, nil, "horizontal")
		end, { buffer = true, desc = "Run python file in ToggleTerm" })
	end,
})

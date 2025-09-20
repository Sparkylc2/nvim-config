-- ==== groups ================================================================
local aug = vim.api.nvim_create_augroup

local fast_ui = aug("FastUI", { clear = true })
local yank_grp = aug("YankHighlight", { clear = true })
local ft_group = aug("FileTypeSettings", { clear = true })
local term_group = aug("TermTweaks", { clear = true })
local open_ext = aug("ExternalOpeners", { clear = true })
local quit_grp = aug("QuitHooks", { clear = true })
local perf_guard = aug("PerfGuard", { clear = true })

-- cursor line stuff
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
-- 	group = fast_ui,
-- 	callback = function()
-- 		vim.wo.cursorline = true
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("WinLeave", {
-- 	group = fast_ui,
-- 	callback = function()
-- 		vim.wo.cursorline = false
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	group = fast_ui,
-- 	callback = function()
-- 		vim.wo.cursorline = false
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	group = fast_ui,
-- 	callback = function()
-- 		vim.wo.cursorline = true
-- 	end,
-- })

-- highlight on yank
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
	callback = function()
		vim.opt_local.buflisted = false
		vim.opt_local.modifiable = false

		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-e>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<A-n>", "\x1b[D", opts) -- left
		vim.keymap.set("t", "<A-o>", "\x1b[C", opts) -- right
		vim.keymap.set("t", "<A-i>", "\x1b[A", opts) -- up
		vim.keymap.set("t", "<A-e>", "\x1b[B", opts) -- down
	end,
})

-- open pdfs in skim
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = open_ext,
	pattern = "*.pdf",
	callback = function()
		local pdf_path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "open", "-a", "Preview", pdf_path }, { detach = true })
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

-- fix for neovim bugging when resizing
vim.api.nvim_create_autocmd({ "VimResized", "FocusGained" }, {
	callback = function()
		vim.schedule(function()
			vim.cmd("redraw!")
			vim.cmd("mode")
		end)
	end,
})

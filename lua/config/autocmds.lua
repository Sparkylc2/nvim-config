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
		local p = require("config.palette")
		local duration = 250

		vim.api.nvim_set_hl(0, "YankFlash", { bg = p.yank_bg })
		vim.hl.on_yank({ higroup = "YankFlash", timeout = duration })

		if Snacks and Snacks.animate then
			Snacks.animate(0, 100, function(value)
				vim.api.nvim_set_hl(0, "YankFlash", { bg = p.blend(p.yank_bg, p.bg, value / 100) })
			end, {
				duration = { step = 8, total = duration },
				easing = "outQuad",
				int = true,
				id = "yank_flash",
			})
		end
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

		vim.keymap.set("n", "<leader>o", function()
			local file = vim.api.nvim_buf_get_name(0)
			if file == "" then
				vim.notify("buffer has no file on disk", vim.log.levels.WARN)
				return
			end
			if file:match("%.ipynb$") then
				vim.notify("that's a notebook -- Typora can't open .ipynb", vim.log.levels.WARN)
				return
			end
			if vim.bo.modified then
				vim.cmd.write()
			end
			vim.system({ "open", "-a", "Typora", file }, { text = true }, function(res)
				if res.code ~= 0 then
					vim.schedule(function()
						vim.notify("Typora: " .. (res.stderr or "failed"), vim.log.levels.ERROR)
					end)
				end
			end)
		end, { buffer = true, desc = "Open in Typora" })
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

		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-e>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<A-esc>", "<esc>", opts)
		vim.keymap.set("t", "<A-n>", "<Left>", opts)
		vim.keymap.set("t", "<A-o>", "<Right>", opts)
		vim.keymap.set("t", "<A-i>", "<Up>", opts)
		vim.keymap.set("t", "<A-e>", "<Down>", opts)
	end,
})

-- open pdfs in my pdf viewer
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
			Snacks.terminal.open(cmd, {
				win = { position = "bottom", height = 0.3 },
				interactive = false,
			})
		end, { buffer = true, desc = "Run python file in a terminal" })
	end,
})

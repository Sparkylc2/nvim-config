local repo_url = "https://github.com/Sparkylc2/ICL-Advanced-Latex-Template.git"
local pkgname = "local"
local cache_dir = vim.fn.expand("~/Documents/GitHub/ICL-Advanced-Latex-Template")

local function texmfhome()
	if vim.fn.executable("kpsewhich") == 1 then
		local out = vim.fn.system("kpsewhich -var-value=TEXMFHOME")
		if vim.v.shell_error == 0 then
			out = vim.trim(out)
			if out ~= "" then
				return out
			end
		end
	end
	return vim.fn.expand("~") .. "/texmf"
end

local function pkg_dir()
	return string.format("%s/tex/latex/%s", texmfhome(), pkgname)
end

local function update_repo()
	if vim.fn.isdirectory(cache_dir .. "/.git") == 1 then
		os.execute(("git -C %s pull --ff-only --quiet"):format(vim.fn.shellescape(cache_dir)))
	else
		vim.fn.delete(cache_dir, "rf") -- ensure empty
		os.execute(("git clone --depth 1 %s %s"):format(vim.fn.shellescape(repo_url), vim.fn.shellescape(cache_dir)))
	end
	return vim.fn.isdirectory(cache_dir .. "/template") == 1 and vim.fn.isdirectory(cache_dir .. "/note_template") == 1
end

local function install_cls()
	local tgt = pkg_dir()
	vim.fn.mkdir(tgt, "p")
	os.execute(("find %s -type l -delete"):format(vim.fn.shellescape(tgt)))
	local files = vim.fn.globpath(cache_dir .. "/config", "*.{cls,sty}", 0, 1)
	for _, src in ipairs(files) do
		local dest = tgt .. "/" .. vim.fn.fnamemodify(src, ":t")
		os.execute(("ln -sf %s %s"):format(vim.fn.shellescape(src), vim.fn.shellescape(dest)))
	end
	vim.notify("cls/sty linked → " .. tgt, vim.log.levels.INFO)
end

local function get_current_directory()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname:match("^oil://") then
		local dir = bufname:gsub("^oil://", "")
		if dir:sub(1, 1) == "~" then
			dir = vim.fn.expand(dir)
		end
		return dir
	end

	local ok, mgr = pcall(require, "neo-tree.sources.manager")
	if ok then
		local state = mgr.get_state("filesystem")
		if state and state.tree then
			local node = state.tree:get_node()
			if node then
				return (node.type == "directory") and node.path or vim.fn.fnamemodify(node.path, ":h")
			end
		end
	end

	return vim.fn.getcwd()
end

local function copy_template(template_dir, template_name)
	if not update_repo() then
		vim.notify("Latex template repo missing required directories", vim.log.levels.ERROR)
		return
	end
	install_cls()

	local dest = get_current_directory()

	if vim.fn.filereadable(dest .. "/main.tex") == 1 then
		local confirm = vim.fn.confirm("main.tex already exists in " .. dest .. "\nOverwrite?", "&Yes\n&No", 2)
		if confirm ~= 1 then
			return
		end
	end

	os.execute(("cp -R %s/. %s"):format(vim.fn.shellescape(cache_dir .. "/" .. template_dir), vim.fn.shellescape(dest)))

	local open_file = dest .. "/main.tex"
	if vim.fn.filereadable(open_file) == 0 then
		local texes = vim.fn.globpath(dest, "*.tex", 0, 1)
		if #texes > 0 then
			open_file = texes[1]
		end
	end

	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname:match("^oil://") then
		pcall(function()
			require("oil").refresh()
		end)
	end

	if vim.fn.filereadable(open_file) == 1 then
		vim.cmd.edit(vim.fn.fnameescape(open_file))
	end

	vim.notify(template_name .. " template copied to " .. dest, vim.log.levels.INFO)
end

local function copy_report_template()
	copy_template("template", "Report")
end

local function copy_notes_template()
	copy_template("note_template", "Notes")
end

vim.api.nvim_create_user_command("LatexSetupInstall", function()
	install_cls()
end, { desc = "Clone/Update repo & relink cls/sty" })

vim.api.nvim_create_user_command(
	"LatexReportHere",
	copy_report_template,
	{ desc = "Copy report template to current directory" }
)
vim.api.nvim_create_user_command(
	"LatexNotesHere",
	copy_notes_template,
	{ desc = "Copy notes template to current directory" }
)

local function setup_latex_keymaps()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "oil",
		callback = function()
			vim.keymap.set(
				"n",
				"<leader>lr",
				copy_report_template,
				{ buffer = true, desc = "Create LaTeX report template here" }
			)
			vim.keymap.set(
				"n",
				"<leader>ln",
				copy_notes_template,
				{ buffer = true, desc = "Create LaTeX notes template here" }
			)
			vim.keymap.set("n", "<leader>li", function()
				vim.cmd("LatexSetupInstall")
			end, { buffer = true, desc = "Install LaTeX cls/sty files" })
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "tex", "latex" },
		callback = function()
			vim.keymap.set(
				"n",
				"<leader>lr",
				copy_report_template,
				{ buffer = true, desc = "Create LaTeX report template here" }
			)
			vim.keymap.set(
				"n",
				"<leader>ln",
				copy_notes_template,
				{ buffer = true, desc = "Create LaTeX notes template here" }
			)
			vim.keymap.set("n", "<leader>li", function()
				vim.cmd("LatexSetupInstall")
			end, { buffer = true, desc = "Install LaTeX cls/sty files" })
		end,
	})
end

setup_latex_keymaps()

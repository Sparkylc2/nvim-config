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

local function current_dir()
	local ok, mgr = pcall(require, "neo-tree.sources.manager")
	if not ok then
		return vim.fn.getcwd()
	end
	local state = mgr.get_state("filesystem")
	if not state or not state.tree then
		return vim.fn.getcwd()
	end
	local node = state.tree:get_node()
	if not node then
		return vim.fn.getcwd()
	end
	return (node.type == "directory") and node.path or vim.fn.fnamemodify(node.path, ":h")
end

local function copy_template_here()
	if not update_repo() then
		vim.notify("Latex template repo missing 'template/' dir", vim.log.levels.ERROR)
		return
	end
	install_cls()

	local dest = current_dir()

	if vim.fn.filereadable(dest .. "/main.tex") == 1 then
		vim.notify("main.tex already exists in " .. dest, vim.log.levels.ERROR)
		return
	end

	os.execute(("cp -R %s/. %s"):format(vim.fn.shellescape(cache_dir .. "/template"), vim.fn.shellescape(dest)))

	local open_file = dest .. "/main.tex"
	if vim.fn.filereadable(open_file) == 0 then
		local texes = vim.fn.globpath(dest, "*.tex", 0, 1)
		if #texes > 0 then
			open_file = texes[1]
		end
	end
	if vim.fn.filereadable(open_file) == 1 then
		vim.cmd.edit(vim.fn.fnameescape(open_file))
	end

	vim.notify("Template copied to " .. dest, vim.log.levels.INFO)
end

local function copy_note_template_here()
	if not update_repo() then
		vim.notify("Latex template repo missing 'template/' dir", vim.log.levels.ERROR)
		return
	end
	install_cls()

	local dest = current_dir()

	if vim.fn.filereadable(dest .. "/main.tex") == 1 then
		vim.notify("main.tex already exists in " .. dest, vim.log.levels.ERROR)
		return
	end

	os.execute(("cp -R %s/. %s"):format(vim.fn.shellescape(cache_dir .. "/note_template"), vim.fn.shellescape(dest)))

	local open_file = dest .. "/main.tex"
	if vim.fn.filereadable(open_file) == 0 then
		local texes = vim.fn.globpath(dest, "*.tex", 0, 1)
		if #texes > 0 then
			open_file = texes[1]
		end
	end
	if vim.fn.filereadable(open_file) == 1 then
		vim.cmd.edit(vim.fn.fnameescape(open_file))
	end

	vim.notify("Template copied to " .. dest, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("LatexSetupInstall", function()
	install_cls()
end, { desc = "Clone/Update repo & relink cls/sty" })

vim.api.nvim_create_user_command(
	"LatexReportHere",
	copy_template_here,
	{ desc = "Copy template into current Neo-tree directory" }
)

vim.api.nvim_create_user_command(
	"LatexNotesHere",
	copy_note_template_here,
	{ desc = "Copy template into current Neo-tree directory" }
)

return {
	{
		"lervag/vimtex",
		ft = "tex",
		init = function()
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1

			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
			vim.g.vimtex_compiler_latexmk = {
				backend = "biber",
				executable = "latexmk",
				continuous = 0,
				options = {
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-shell-escape",
				},
			}
			vim.g.vimtex_bibliography_autoload = {
				filenames = { "**/bibliography/*.bib" },
			}
		end,
		keys = {
			{ "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
			{ "<leader>lv", "<cmd>VimtexView<cr>", desc = "View PDF" },
			{ "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle TOC" },
			{ "<leader>ll", "<cmd>VimtexCompileSS<cr>", desc = "Start continuous compilation" },
			{ "<leader>ls", "<cmd>VimtexStop<cr>", desc = "Stop compilation" },
			{ "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Show errors" },
		},
		config = function()
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.tex",
				callback = function()
					if vim.fn.exists(":VimtexCompile") == 2 then
						vim.cmd("silent VimtexCompile")
					end
				end,
			})
		end,
	},
}

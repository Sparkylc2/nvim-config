return {
	{
		"neovim/nvim-lspconfig",
		ft = { "c", "cpp", "cxx", "cc" },
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			lspconfig.clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--std=c++20",
					"--limit-results=50",
					"--compile-commands-dir=.",
					"--pch-storage=memory",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = false,
					clangdFileStatus = true,
				},
				capabilities = capabilities,
				settings = {
					clangd = {

						InlayHints = {
							Designators = false,
							Enabled = false,
							ParameterNames = false,
							DeducedTypes = false,
						},
						SemanticHighlighting = false,
					},
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.semanticTokensProvider = nil

					if client.server_capabilities.signatureHelpProvider then
						client.server_capabilities.signatureHelpProvider.triggerCharacters = { "(", "," }
					end

					vim.bo[bufnr].updatetime = 400

					local line_count = vim.api.nvim_buf_line_count(bufnr)
					if line_count > 1000 then
						client.server_capabilities.documentHighlightProvider = nil
						vim.bo[bufnr].updatetime = 800
					end
				end,
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern(
						"Makefile",
						"configure.ac",
						"configure.in",
						"config.h.in",
						"meson.build",
						"meson_options.txt",
						"build.ninja",
						"compile_commands.json",
						"compile_flags.txt",
						".git"
					)(fname)
				end,
			})
		end,
	},
	-- {
	-- 	"p00f/clangd_extensions.nvim",
	-- 	ft = { "c", "cpp", "cxx", "cc" },
	-- 	config = function()
	-- 		require("clangd_extensions").setup({
	-- 			inlay_hints = {
	-- 				inline = false,
	-- 				only_current_line = false,
	-- 				show_parameter_hints = false,
	-- 				parameter_hints_prefix = "<- ",
	-- 				other_hints_prefix = "=> ",
	-- 				max_len_align = false,
	-- 				max_len_align_padding = 1,
	-- 				right_align = false,
	-- 				right_align_padding = 7,
	-- 				highlight = "Comment",
	-- 			},
	-- 			ast = {
	-- 				role_icons = {
	-- 					type = "",
	-- 					declaration = "",
	-- 					expression = "",
	-- 					specifier = "",
	-- 					statement = "",
	-- 					["template argument"] = "",
	-- 				},
	-- 				kind_icons = {
	-- 					Compound = "",
	-- 					Recovery = "",
	-- 					TranslationUnit = "",
	-- 					PackExpansion = "",
	-- 					TemplateTypeParm = "",
	-- 					TemplateTemplateParm = "",
	-- 					TemplateParamObject = "",
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			pattern = { "c", "cpp", "cxx", "cc" },
	-- 			callback = function()
	-- 				local bufnr = vim.api.nvim_get_current_buf()
	--
	-- 				-- Set up keymaps
	-- 				vim.keymap.set(
	-- 					"n",
	-- 					"<leader>ch",
	-- 					"<cmd>ClangdSwitchSourceHeader<cr>",
	-- 					{ desc = "Switch Source/Header (C/C++)", buffer = bufnr }
	-- 				)
	-- 				vim.keymap.set(
	-- 					"n",
	-- 					"<leader>ct",
	-- 					"<cmd>ClangdTypeHierarchy<cr>",
	-- 					{ desc = "Type Hierarchy", buffer = bufnr }
	-- 				)
	--
	-- 				-- Performance optimizations for C++ buffers
	-- 				local line_count = vim.api.nvim_buf_line_count(bufnr)
	--
	-- 				if line_count > 2000 then
	-- 					-- Disable expensive features for very large files
	-- 					vim.notify("Large C++ file detected - optimizing for performance", vim.log.levels.INFO)
	-- 					vim.b[bufnr].blink_completion_enabled = false
	-- 					vim.bo[bufnr].syntax = "off"
	-- 				elseif line_count > 500 then
	-- 					-- Reduce completion frequency for medium files
	-- 					vim.b[bufnr].completion_trigger_delay = 200
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"Civitasv/cmake-tools.nvim",
	-- 	ft = { "c", "cpp", "cxx", "cc", "cmake" },
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	config = function()
	-- 		require("cmake-tools").setup({
	-- 			cmake_command = "cmake",
	-- 			cmake_build_directory = "build",
	-- 			cmake_build_type = "Debug",
	-- 			cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
	-- 			cmake_build_options = {},
	-- 			cmake_console_size = 10,
	-- 			cmake_show_console = "always",
	-- 			cmake_dap_configuration = {
	-- 				name = "cpp",
	-- 				type = "codelldb",
	-- 				request = "launch",
	-- 				stopOnEntry = false,
	-- 				runInTerminal = true,
	-- 				console = "integratedTerminal",
	-- 			},
	-- 		})
	--
	-- 		-- Add keymaps for cmake-tools
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			pattern = { "c", "cpp", "cxx", "cc", "cmake" },
	-- 			callback = function()
	-- 				local bufnr = vim.api.nvim_get_current_buf()
	-- 				vim.keymap.set(
	-- 					"n",
	-- 					"<leader>cg",
	-- 					"<cmd>CMakeGenerate<cr>",
	-- 					{ desc = "CMake Generate", buffer = bufnr }
	-- 				)
	-- 				vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build", buffer = bufnr })
	-- 				vim.keymap.set("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run", buffer = bufnr })
	-- 				vim.keymap.set("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug", buffer = bufnr })
	-- 				vim.keymap.set("n", "<leader>cc", "<cmd>CMakeClean<cr>", { desc = "CMake Clean", buffer = bufnr })
	-- 			end,
	-- 		})
	-- 	end,
	-- },
}

local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("IncludeFormatter", { clear = true })

	-- C/C++ include formatter
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = { "c", "cpp" },
		callback = function(args)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				buffer = args.buf,
				callback = function()
					require("tools.cpp.include_formatter").format(args.buf)
				end,
			})
		end,
	})

	-- :Skel command
	vim.api.nvim_create_user_command("Skel", function()
		require("tools.cpp.skeleton").insert()
	end, {})

	require("tools.cpp.cpp_trivial_constructor").setup()
	require("tools.cpp.cpp_extract").setup()
	require("tools.cpp.include_rename").setup()
end

return M

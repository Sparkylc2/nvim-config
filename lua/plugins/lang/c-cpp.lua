return {
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "objc", "objcpp" },
		config = function()
			require("clangd_extensions").setup({
				inlay_hints = {
					inline = true,
					only_current_line = false,
					show_parameter_hints = true,
					parameter_hints_prefix = "<- ",
					other_hints_prefix = "=> ",
				},
			})
		end,
	},
}

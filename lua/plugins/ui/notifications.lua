return {
	{
		"rcarriga/nvim-notify",
        enabled = false,
		config = function()
			require("notify").setup({
				background_colour = "#000000",
				render = "minimal",
				stages = "fade",
			})
			vim.notify = require("notify")
		end,
	},
}

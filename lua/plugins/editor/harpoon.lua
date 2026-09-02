return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		-- harpoon require()s plenary at runtime but does not declare it. It only
		-- worked before because telescope pulled plenary in; removing telescope
		-- took plenary with it and harpoon started failing to load.
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					save_on_change = true,
					sync_on_ui_close = true,
					key = function()
						return vim.loop.cwd()
					end,
				},
			})

			local list = function()
				return harpoon:list()
			end
			local ui = harpoon.ui

			vim.keymap.set("n", "<leader>a", function()
				list():add()
			end, { desc = "Harpoon: add file" })
			vim.keymap.set("n", "<leader>h", function()
				ui:toggle_quick_menu(list())
			end, { desc = "Harpoon: menu" })

			vim.keymap.set("n", "<leader>1", function()
				list():select(1)
			end, { desc = "Harpoon: file 1" })
			vim.keymap.set("n", "<leader>2", function()
				list():select(2)
			end, { desc = "Harpoon: file 2" })
			vim.keymap.set("n", "<leader>3", function()
				list():select(3)
			end, { desc = "Harpoon: file 3" })
			vim.keymap.set("n", "<leader>4", function()
				list():select(4)
			end, { desc = "Harpoon: file 4" })
			vim.keymap.set("n", "<leader>5", function()
				list():select(5)
			end, { desc = "Harpoon: file 5" })

			vim.keymap.set("n", "<leader>hp", function()
				list():prev()
			end, { desc = "Harpoon: prev" })
			vim.keymap.set("n", "<leader>hn", function()
				list():next()
			end, { desc = "Harpoon: next" })

			vim.keymap.set("n", "<leader>hx", function()
				harpoon:list():remove()
			end, { desc = "Harpoon: remove current buffer from list" })
		end,
	},
}

-- lua/plugins/profile.lua
return {
	{
		"stevearc/profile.nvim",
		enabled = false,
		lazy = false,
		config = function()
			local profile = require("profile")

			-- record autocommands too (handy for runtime stalls)
			profile.instrument_autocmds()

			profile.instrument("*")

			-- Toggle & save with <F1>
			local function toggle()
				if profile.is_recording() then
					profile.stop()
					vim.ui.input(
						{ prompt = "Save profile to:", completion = "file", default = "profile.json" },
						function(fname)
							if fname then
								profile.export(fname)
								vim.notify("Wrote " .. fname)
							end
						end
					)
				else
					profile.start("*")
				end
			end
			vim.api.nvim_create_user_command("TP", function()
				toggle()
			end, {})
		end,
	},
}

-- Smooth scrolling with shortcuts
return {
	"karb94/neoscroll.nvim",
	config = function()
		local neoscroll = require("neoscroll")
		local keymap = {
			["<leader>u"] = function()
				neoscroll.ctrl_u({ duration = 190 })
			end,
			["<leader>d"] = function()
				neoscroll.ctrl_d({ duration = 190 })
			end,
		}
		local modes = { "n", "v", "x" }

		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func)
		end
	end,
}

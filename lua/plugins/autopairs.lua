-- Adds pairing brackets and quotes

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependences = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}

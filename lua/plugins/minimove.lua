-- Moves V selected lines with alt j/k
return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.move").setup({})
	end,
}

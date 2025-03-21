-- add ys{motion}{char}, delete ds{char}, cs{target}{replacement}
return {
	"kylechui/nvim-surround",
	version = "^3.0.0",
    event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({})
	end,
}


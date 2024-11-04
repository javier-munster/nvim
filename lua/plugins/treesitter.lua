return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- ensure these language parsers are installed
			ensure_installed = {
				"c",
				"lua",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"rust",
				"json",
				"cpp",
				"python",
				"bash",
				"go",
				"sql",
				"prisma",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-y>",
					node_incremental = "<C-y>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- ensure these language parsers are installed
			ensure_installed = {
                -- "angular",
				"bash",
				"c",
				"cpp",
				"css",
                "diff",
                "gitignore",
				"go",
				"html",
				"javascript",
                "jsdoc",
				"json",
				"lua",
				"prisma",
				"python",
                "scss",
				"sql",
				"tsx",
				"typescript",
                "xml",
                "yaml",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
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

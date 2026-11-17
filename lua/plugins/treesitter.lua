-- Parsers to keep installed; anything else is installed on demand below.
local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"diff",
	"embedded_template",
	"gitignore",
	"go",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"prisma",
	"python",
	"ruby",
	"scss",
	"sql",
	"tsx",
	"typescript",
	"xml",
	"yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	-- main is a rewrite: it has no module system, does not support lazy-loading,
	-- and needs its parsers rebuilt whenever the plugin itself updates.
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local incremental = require("util.ts_incremental")

		ts.install(parsers)

		-- Highlighting is Neovim's job now, started per buffer. Installing a
		-- missing parser here is what used to be auto_install.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserTreesitter", {}),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang or pcall(vim.treesitter.start, ev.buf, lang) then
					return
				end

				if vim.tbl_contains(ts.get_available(), lang) then
					ts.install({ lang }):await(function()
						vim.schedule(function()
							if vim.api.nvim_buf_is_valid(ev.buf) then
								pcall(vim.treesitter.start, ev.buf, lang)
							end
						end)
					end)
				end
			end,
		})

		vim.keymap.set({ "n", "x" }, "<C-y>", incremental.expand, { desc = "Expand selection to node" })
		vim.keymap.set("x", "<bs>", incremental.shrink, { desc = "Shrink selection to previous node" })
	end,
}

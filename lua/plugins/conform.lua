return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local supabase = require("util.supabase")

		-- Deno owns supabase/functions/; elsewhere biome, falling back to
		-- prettier in projects that have no biome config.
		local function web(bufnr)
			if supabase.functions_root(bufnr) then
				return { "deno_fmt" }
			end

			return { "biome", "prettier", stop_after_first = true }
		end

		conform.setup({
			formatters = {
				-- Without this biome would also claim non-biome projects,
				-- formatting them with its built-in defaults.
				biome = { require_cwd = true },
			},
			formatters_by_ft = {
				javascript = web,
				typescript = web,
				javascriptreact = web,
				typescriptreact = web,
				json = web,
				jsonc = web,
				css = web,
				-- Not handled by biome
				scss = { "prettier" },
				html = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- ruby-lsp defers to whatever the project already uses
				-- (rubocop, syntax_tree), so there is no global tool to keep in sync
				ruby = { lsp_format = "prefer" },
				go = { "goimports", "gofumpt" },
				sh = { "shfmt" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format()
		end, { desc = "Format file or range (in visual mode)" })
	end,
}

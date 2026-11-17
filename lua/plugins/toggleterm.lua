return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
            insert_mappings = false,
			open_mapping = '<C-\\>',
		})

		local lazygit = require("toggleterm.terminal").Terminal:new({
			cmd = "lazygit",
			direction = "float",
			on_open = function(term)
				local opts = { buffer = term.bufnr, silent = true }
				-- let <esc> reach lazygit (it means "go back a view") instead of
				-- hitting the global t-mode <esc> -> normal mode mapping
				vim.keymap.set("t", "<esc>", "<esc>", opts)
				-- escape hatch: drop to normal mode so :q and friends work
				vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)
			end,
		})

		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>g', ':lua _lazygit_toggle()<CR>', { desc = "Lazygit"})
	end,
}

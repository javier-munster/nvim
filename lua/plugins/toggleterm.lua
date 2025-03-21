return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
            insert_mappings = false,
			open_mapping = '<C-\\>',
		})

		local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", direction = "float" })

		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>g', ':lua _lazygit_toggle()<CR>', { desc = "Lazygit"})
	end,
}

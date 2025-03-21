-- Show LSP Symbols
return {
    'stevearc/aerial.nvim',
    config = function()
        require("aerial").setup({
            close_automatic_events = { unfocus, switch_buffer },
            on_attach = function(bufnr)
                vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,
        })

        vim.keymap.set("n", "<leader>v", ":Telescope aerial<CR>", { desc = "Opens Symbols explorer"})
    end

}

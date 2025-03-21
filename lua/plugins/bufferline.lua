-- Tab line at the top
return {
    "akinsho/bufferline.nvim", version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        options = {
            mode = "tabs",
            separator_style = "slant",
        },
    },
    config = function()
        vim.keymap.set(
            "n",
            "<Tab>",
            "<cmd>bn<CR>",
            { desc = "Next tab" }
        )
        vim.keymap.set(
            "n",
            "<S-Tab>",
            "<cmd>bp<CR>",
            { desc = "Previous tab" }
        )
    end,
}

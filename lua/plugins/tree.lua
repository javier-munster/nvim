-- File explorer
return {
    "nvim-tree/nvim-tree.lua",
    name = "nvim-tree",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            actions = {
                open_file = {
                    quit_on_open = true,
                }
            },
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 60,
                relativenumber = true,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                git_ignored = false,
                dotfiles = false,
            },
            git = {
                ignore = false,
            },
        })
        -- vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set(
            "n",
            "<leader>e",
            "<cmd>NvimTreeFindFileToggle<CR>",
            { desc = "Toggle file explorer on current file" }
        )
    end,
}

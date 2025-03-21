return {
    "lukas-reineke/indent-blankline.nvim",
    name = "ibl",
    config = function ()
        require("ibl").setup({
            indent = {
                char = "▏"
            },
        })
    end,
}

-- Colours CSS colour codes
-- catgoose's fork: norcalli/ has been unmaintained since 2021 and still calls
-- vim.tbl_flatten, which Neovim removes in 0.13.
return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
        require("colorizer").setup()
    end,
}

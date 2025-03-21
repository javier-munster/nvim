-- Allows for hopping to word on file
return {
    'smoka7/hop.nvim',
    config = function()
        require('hop').setup({
            tag = '*'
        })
        vim.keymap.set(
            "n",
            "f",
            ':lua require("hop").hint_words({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })<CR>',
            {
                remap = true,
                desc = "Hop forward"
            }
        )
        vim.keymap.set(
            "n",
            "F",
            ':lua require("hop").hint_words({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })<CR>',
            {
                remap = true,
                desc = "Hop backward"
            }
        )
        -- vim.keymap.set(
        --     "n",
        --     "t",
        --     ':lua require("hop").hint_words({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, hint_offset = -1 })<CR>',
        --     {
        --         remap = true,
        --         desc = "Hop backward after cursor"
        --     }
        -- )
        -- vim.keymap.set(
        --     "n",
        --     "T",
        --     ':lua require("hop").hint_words({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, hint_offset = -1 })<CR>',
        --     {
        --         remap = true,
        --         desc = "Hop backward after cursor"
        --     }
        -- )
    end
}

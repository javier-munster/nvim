-- Incremental selection: the nvim-treesitter main branch dropped its module
-- system, so the <C-y>/<bs> behaviour lives here now.
local M = {}

-- Per buffer stack of the ranges we grew out of, so shrinking can retrace them.
---@type table<integer, integer[][]>
local history = {}

---@return integer[]|nil {start_row, start_col, end_row, end_col}, end exclusive
local function visual_range()
    local mode = vim.fn.mode()
    if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
        return nil
    end

    local anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
    local srow, scol = anchor[2] - 1, anchor[3] - 1
    local erow, ecol = cursor[2] - 1, cursor[3] - 1

    if srow > erow or (srow == erow and scol > ecol) then
        srow, scol, erow, ecol = erow, ecol, srow, scol
    end

    return { srow, scol, erow, ecol + 1 }
end

---@param range integer[]
local function select_range(range)
    local srow, scol, erow, ecol = unpack(range)

    if vim.fn.mode() ~= "n" then
        vim.cmd.normal({ vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true })
    end

    vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
    vim.cmd.normal({ "v", bang = true })
    vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
end

---@param node TSNode
---@param range integer[]
---@return boolean
local function contains_more_than(node, range)
    local srow, scol, erow, ecol = node:range()

    return (srow < range[1] or (srow == range[1] and scol < range[2]))
        or (erow > range[3] or (erow == range[3] and ecol > range[4]))
end

--- Select the node under the cursor, or grow the selection to the next parent.
function M.expand()
    local buf = vim.api.nvim_get_current_buf()
    local range = visual_range()
    local ok, node = pcall(vim.treesitter.get_node, {
        bufnr = buf,
        pos = range and { range[1], range[2] } or nil,
    })

    if not ok or not node then
        return
    end

    if range then
        while node and not contains_more_than(node, range) do
            node = node:parent()
        end

        if not node then
            return
        end

        history[buf] = history[buf] or {}
        table.insert(history[buf], range)
    else
        history[buf] = {}
    end

    local srow, scol, erow, ecol = node:range()
    select_range({ srow, scol, erow, ecol })
end

--- Step back to the selection we grew out of.
function M.shrink()
    local buf = vim.api.nvim_get_current_buf()
    local previous = history[buf] and table.remove(history[buf])

    if previous then
        select_range(previous)
    end
end

vim.api.nvim_create_autocmd("BufDelete", {
    group = vim.api.nvim_create_augroup("UserTsIncremental", {}),
    callback = function(ev)
        history[ev.buf] = nil
    end,
})

return M

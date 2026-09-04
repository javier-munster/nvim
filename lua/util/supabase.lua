local M = {}

-- Supabase edge functions are Deno, and live in supabase/functions/.
-- Returns the path of that directory when the buffer is inside it, so both the
-- LSP and the formatter setup can switch over to the Deno toolchain there.
---@param bufnr? integer
---@return string|nil
function M.functions_root(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr or 0)
    if fname == "" then
        return nil
    end

    return (vim.fs.normalize(fname):match("^(.*/supabase/functions)/"))
end

return M

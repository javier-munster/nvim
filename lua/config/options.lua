local options = {
    number = true, -- show line numbers
    relativenumber = true, -- show relative line numbers
    expandtab = true, -- expand tabs to spaces
    tabstop = 4, -- 4 spaces for tab
    shiftwidth = 4, -- 4 spaces for tab
    incsearch = true, -- search while typing
    ignorecase = true, -- case insensitive search
    smartcase = true, -- case sensitive search when using capital letters
    hidden = true, -- switch buffers without saving
    cursorline = true, -- highlight current line
    -- colorcolumn = "80", -- show guide at 80 chars
    splitbelow = true, -- split vertical windows below
    splitright = true, -- split horizontal windows right
    smartindent = true, -- auto indent inside braces
    breakindent = true, -- keep indentation for wrapped lines
    scrolloff = 999, -- keep cursor in middle of window
    signcolumn = "yes", -- keep 1 column for LSP check
    clipboard = "unnamed", -- use system clipboard
    timeoutlen = 500, -- command timeout
    termguicolors = true, -- allow opacity
    -- powershell options
    -- shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    -- shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    -- shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    -- shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    -- shellquote = "",
    -- shellxquote = "",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.g.mapleader = " "

local keymap = vim.keymap

-- window splitting
keymap.set("n", "<leader>-", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>_", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- keymap.set("n", "<leader>e", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split

keymap.set("n", "<leader>t", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) -- go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) -- go to previous tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("t", "<esc>", [[<C-\><C-n>]])

keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
keymap.set("n", "<leader>w", ":up<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })

-- Reselect visual block after indent/outdent
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

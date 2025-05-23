return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "angularls",
            "html",
            "cssls",
            "ts_ls",
            "jsonls",
            "pyright",
            "gopls",
            "angularls",
            "clangd",
            "lua_ls",
            "rust_analyzer",
            "tailwindcss",
        },
        automatic_enable = {
            exclude = {
                "denols",
            }
        }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "isort",
                    "black",
                    "gofumpt",
                    "goimports",
                    "shfmt",
                }
            }
        },
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementions"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>Y", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>y", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostics"
				vim.keymap.set("n", "[y", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]y", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- opts.desc = "Restart LSP"
				-- vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
    end,
}

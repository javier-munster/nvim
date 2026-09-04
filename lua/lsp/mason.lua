local servers = {
    "angularls",
    "html",
    "cssls",
    "ts_ls",
    "jsonls",
    "pyright",
    "gopls",
    "clangd",
    "lua_ls",
    "rust_analyzer",
    "ruby_lsp",
    "tailwindcss",
    "postgres_lsp",
    "biome",
}

-- Installed, but configured/enabled by hand below so that our custom root_dir
-- is not bypassed by mason-lspconfig's automatic_enable.
local manual_servers = {
    "denols",
}

local supabase = require("util.supabase")

return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = vim.list_extend(vim.list_slice(servers), manual_servers),
        automatic_enable = {
            exclude = manual_servers,
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

        require("mason").setup()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Captured before we override it, so the wrapper can fall back to
        -- lspconfig's own (monorepo aware) detection.
        local ts_ls_root_dir = (vim.lsp.config["ts_ls"] or {}).root_dir

        for _, server in ipairs(servers) do
            local opts = { capabilities = capabilities, }

            if server == "lua_ls" then
                opts.settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "require" },
                        },
                    },
                }
            elseif server == "ts_ls" then
                -- Hand supabase/functions/ over to denols.
                opts.root_dir = function(bufnr, on_dir)
                    if supabase.functions_root(bufnr) then
                        return
                    end

                    if ts_ls_root_dir then
                        ts_ls_root_dir(bufnr, on_dir)
                    else
                        on_dir(vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" }) or vim.fn.getcwd())
                    end
                end
            elseif server == "angularls" then
                -- Without this it attaches to every TS buffer with a nil root,
                -- since lspconfig leaves workspace_required off.
                opts.root_dir = function(bufnr, on_dir)
                    if supabase.functions_root(bufnr) then
                        return
                    end

                    local root = vim.fs.root(bufnr, { "angular.json", "nx.json" })

                    if root then
                        on_dir(root)
                    end
                end
            elseif server == "postgres_lsp" then
                -- Also start in Supabase projects, not only in ones carrying a
                -- postgres-language-server config file.
                opts.root_dir = function(bufnr, on_dir)
                    local root = vim.fs.root(bufnr, { "postgres-language-server.jsonc", "postgrestools.jsonc" })
                        or vim.fs.root(bufnr, { "supabase" })

                    if root then
                        on_dir(root)
                    end
                end
            end

            vim.lsp.config[server] = opts
            vim.lsp.enable(server)
        end

        -- Deno: Supabase edge functions only.
        vim.lsp.config["denols"] = {
            capabilities = capabilities,
            root_dir = function(bufnr, on_dir)
                local root = supabase.functions_root(bufnr)

                if root then
                    on_dir(root)
                end
            end,
            settings = {
                deno = {
                    enable = true,
                    lint = true,
                },
            },
            before_init = function(_, config)
                local import_map = config.root_dir and config.root_dir .. "/import_map.json"

                if import_map and vim.uv.fs_stat(import_map) then
                    config.settings.deno.importMap = import_map
                end
            end,
        }
        vim.lsp.enable("denols")
	end,
}

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
                    -- nvim-treesitter's main branch builds parsers with it
                    "tree-sitter-cli",
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

				-- goto_prev/goto_next are deprecated, removed in nvim 0.13.
				-- jump() does not open the float on its own, so ask for it.
				opts.desc = "Go to previous diagnostics"
				vim.keymap.set("n", "[y", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]y", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- opts.desc = "Restart LSP"
				-- vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

        require("mason").setup()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- supabase/functions/ belongs to denols, so keep the other JS/TS
        -- servers out of it while leaving their own root detection intact.
        -- Wrapping lspconfig's logic rather than restating it means upstream
        -- marker changes keep working; when a server only declares
        -- root_markers we require a match, so it cannot attach with a nil root.
        local function skipping_supabase_functions(server)
            local config = vim.lsp.config[server] or {}
            local root_dir, root_markers = config.root_dir, config.root_markers

            return function(bufnr, on_dir)
                if supabase.functions_root(bufnr) then
                    return
                end

                if root_dir then
                    return root_dir(bufnr, on_dir)
                end

                local root = root_markers and vim.fs.root(bufnr, root_markers)

                if root then
                    on_dir(root)
                end
            end
        end

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
            elseif server == "ts_ls" or server == "biome" or server == "angularls" then
                opts.root_dir = skipping_supabase_functions(server)
            elseif server == "ruby_lsp" then
                -- No RuboCop diagnostics: projects that never followed its
                -- defaults light up every line. Syntax errors still show.
                opts.init_options = { linters = {} }

                if vim.fn.executable("rbenv") == 1 then
                    -- Mason's ruby-lsp is pinned to the Ruby it was installed with,
                    -- which breaks projects whose Gemfile wants another version.
                    -- rbenv exec runs in root_dir, so it picks the project's Ruby.
                    -- Needs `gem install ruby-lsp` for each Ruby version in use.
                    opts.cmd = { "rbenv", "exec", "ruby-lsp" }
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

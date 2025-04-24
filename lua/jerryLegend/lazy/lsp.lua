return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "ts_ls",
                "clangd",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup({
                        capabilities = capabilities,
                        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
                        init_options = {
                            plugins = {
                                {
                                    name = "@styled/typescript-styled-plugin",
                                    location = "node_modules/@styled/typescript-styled-plugin"
                                }
                            }
                        }
                    })
                end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                    }
                end
            }
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            virtual_text = false, -- if you don’t want inline text
            signs = true,
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            float = {
                show_header = true,
                source = 'always',
                border = 'rounded',
            },
        })
        vim.cmd([[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
        --vim.diagnostic.config({
        --    float = {
        --        focusable = false,
        --        style = "minimal",
        --        border = "rounded",
        --        source = "always",
        --        header = "",
        --        prefix = "",
        --    },
        --})
        -- Copilot configuration
        -- vim.g.copilot_no_tab_map = true
        -- vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end
}

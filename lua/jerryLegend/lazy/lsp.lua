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
            cmp_lsp.default_capabilities()
        )

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
                end,
                require('lspconfig').dartls.setup {
                    on_attach = function(client, bufnr)
                        local opts = { noremap = true, silent = true, buffer = bufnr }

                        -- Set <leader>fl to trigger code actions
                        vim.keymap.set("n", "<leader>fl", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("v", "<leader>fl", vim.lsp.buf.code_action, opts)
                    end,
                }
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
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
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Define diagnostic signs (using current Neovim API style)
        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.diagnostic.config({
            virtual_text = false,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN]  = " ",
                    [vim.diagnostic.severity.HINT]  = " ",
                    [vim.diagnostic.severity.INFO]  = " ",
                },
            },
            float = {
                show_header = true,
                source = "always",
                border = "rounded",
            },
        })

        -- Auto show diagnostics float on hover
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "BufLeave", "WinLeave" },
                    border = "rounded",
                    source = "always",
                })
            end,
        })

        -- Close only the diagnostic float (not signs/underlines) when moving
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                for _, winid in ipairs(vim.api.nvim_list_wins()) do
                    local config = vim.api.nvim_win_get_config(winid)
                    -- Only close floating diagnostic windows
                    if config.relative ~= "" and config.zindex ~= nil then
                        local bufnr = vim.api.nvim_win_get_buf(winid)
                        if vim.bo[bufnr].filetype == "markdown" or vim.bo[bufnr].filetype == "plaintext" then
                            pcall(vim.api.nvim_win_close, winid, true)
                        end
                    end
                end
            end,
        })
    end
}

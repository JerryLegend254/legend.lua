return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile", "InsertLeave" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                html = { { "prettierd", "prettier" } },
                php = { { "tlint" } },
                templ = { { "templ", "gofumpt" } },
                tmpl = { { "templ", "gofumpt" } },
                proto = { { "buf" } },
            },
            format_on_save = {

                timeout_ms = 500,
                lsp_fallback = true,
            }

        })
        conform.format({
            lsp_format = "first"
        })
        vim.keymap.set({ "n", "v" }, "<leader>l", function()
            conform.format({

                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end
}

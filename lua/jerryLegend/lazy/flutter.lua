return {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
    },
    config = function()
        require("flutter-tools").setup {
            flutter_path = "/home/jamy/flutter/bin/flutter",
            widget_guides = {
                enabled = true,
            },
            lsp = {
                on_attach = function(client, bufnr)
                    local opts = { buffer = bufnr, noremap = true, silent = true }

                    -- Optional custom keymaps
                    vim.keymap.set("n", "<leader>fl", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<CR>", opts)
                    vim.keymap.set("n", "<leader>fh", "<cmd>FlutterHotReload<CR>", opts)
                    vim.keymap.set("n", "<leader>fR", "<cmd>FlutterHotRestart<CR>", opts)
                    vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", opts)
                end,
            },
        }
    end,
}

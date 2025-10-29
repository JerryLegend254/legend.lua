return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = { "node_modules" },
                find_command = nil,
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case'
                },
                sorting_strategy = "descending",
                layout_config = { prompt_position = "top" },
                path_display = { "smart" },
            },

            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                }
            }
        })

        -- Load fzf-native for speed
        require("telescope").load_extension("fzf")

        -- 🔹 Your original remaps
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
    end
}

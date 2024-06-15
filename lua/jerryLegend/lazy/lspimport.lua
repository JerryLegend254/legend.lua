return {
    "stevanmilic/nvim-lspimport",
    config = function()
        vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true })
    end
}

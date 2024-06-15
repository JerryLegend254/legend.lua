return {
    "windwp/nvim-ts-autotag",
    config = function()
        local nta = require("nvim-ts-autotag")
        nta.setup({
            ots = {
                enable = true,
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = false,
            },
        })
    end,
}

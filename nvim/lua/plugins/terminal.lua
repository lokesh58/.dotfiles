return {
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<M-/>",
                function()
                    require("snacks").terminal()
                end,
                mode = { "n", "t" },
                desc = "Toggle Terminal",
            },
        },
    },
}

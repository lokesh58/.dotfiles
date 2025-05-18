return {
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<C-`>",
                function()
                    require("snacks").terminal()
                end,
                mode = { "n", "t" },
                desc = "Toggle Terminal",
            },
        },
    },
}

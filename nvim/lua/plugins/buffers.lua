return {
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>bd",
                function()
                    require("snacks").bufdelete()
                end,
                desc = "Close current buffer",
            },
            {
                "<leader>bo",
                function()
                    require("snacks").bufdelete.other()
                end,
                desc = "Close all other buffers",
            },
            {
                "<leader>ba",
                function()
                    require("snacks").bufdelete.all()
                end,
                desc = "Close all buffers",
            },
        },
    },
}

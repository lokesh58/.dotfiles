return {
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = false,
        opts = {},
        command = "Refactor",
        keys = {
            {
                "<leader>r",
                function()
                    require("refactoring").select_refactor({ prefer_ex_cmd = true })
                end,
                mode = { "n", "x" },
                desc = "Refactor",
            },
        },
    },
}

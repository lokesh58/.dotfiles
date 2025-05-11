return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    keys = {
        {
            "<leader>rr",
            function()
                require("refactoring").select_refactor()
            end,
            desc = "Refactor code",
            mode = { "n", "x" },
        },
    },
}

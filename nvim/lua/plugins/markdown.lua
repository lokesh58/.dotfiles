return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = { blink = { enabled = true } },
        file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
}

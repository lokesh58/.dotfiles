local markdown_file_types = { "markdown", "codecompanion" }

return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            completions = { blink = { enabled = true } },
            file_types = markdown_file_types,
        },
        ft = markdown_file_types,
    },
}

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            markdown = { "markdownlint-cli2" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            desc = "Format code",
        },
    },
}

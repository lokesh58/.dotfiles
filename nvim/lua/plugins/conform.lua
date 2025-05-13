return {
    "stevearc/conform.nvim",
    cond = false,
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
        format_on_save = {
            timeout_ms = 500,
        },
    },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            desc = "Format code",
        },
    },
}

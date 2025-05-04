return {
    "mfussenegger/nvim-lint",
    config = function()
        require("lint").linters_by_ft = {
            markdown = { "markdownlint-cli2" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}

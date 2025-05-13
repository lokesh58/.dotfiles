return {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim", "davidmh/cspell.nvim" },
    config = function()
        local null_ls = require("null-ls")
        local cspell = require("cspell")

        null_ls.setup({
            sources = {
                -- Lua
                null_ls.builtins.formatting.stylua,

                -- Spelling
                cspell.diagnostics.with({
                    diagnostics_postprocess = function(diagnostic)
                        diagnostic.severity = vim.diagnostic.severity.HINT
                    end,
                }),
                cspell.code_actions,

                -- JS/TS
                require("none-ls.diagnostics.eslint_d").with({
                    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                }),
                require("none-ls.code_actions.eslint_d").with({
                    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                }),
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                }),

                -- Markdown
                null_ls.builtins.diagnostics.markdownlint_cli2.with({
                    filetypes = { "markdown" },
                }),
                -- null_ls.builtins.code_actions.markdownlint_cli2.with({
                --     filetypes = { "markdown" },
                -- }),
            },
        })

        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("null-ls", { clear = true }),
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
}

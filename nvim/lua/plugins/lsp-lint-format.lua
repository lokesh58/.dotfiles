return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP
            "saghen/blink.cmp",
            "folke/snacks.nvim",
            { "smjonas/inc-rename.nvim", opts = { save_in_cmdline_history = false } },
            { "aznhe21/actions-preview.nvim", opts = {} },
            "SmiteshP/nvim-navic",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    -- setup LSP specific keymaps
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    vim.keymap.set("n", "grn", function()
                        return ":IncRename " .. vim.fn.expand("<cword>")
                    end, { desc = "Rename symbol", expr = true })
                    map("gra", require("actions-preview").code_actions, "Goto Code Action", { "n", "x" })
                    map("grr", require("snacks").picker.lsp_references, "Goto References")
                    map("gri", require("snacks").picker.lsp_implementations, "Goto Implementation")
                    map("grd", require("snacks").picker.lsp_definitions, "Goto Definition")
                    map("grD", require("snacks").picker.lsp_declarations, "Goto Declaration")
                    map("grt", require("snacks").picker.lsp_type_definitions, "Goto Type Definition")
                    map("gO", require("snacks").picker.lsp_symbols, "Open Document Symbols")
                    map("gW", require("snacks").picker.lsp_workspace_symbols, "Open Workspace Symbols")
                    map("grl", vim.diagnostic.open_float, "Open Diagnostics")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                    then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if
                        client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                    then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "Toggle Inlay Hints")
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                lua_ls = {},
                marksman = {},
                vtsls = {},
                clangd = {},
                neocmake = {},
                pyright = {},
                ["rust-analyzer"] = {},
                ["docker-compose-language-service"] = {},
                ["dockerfile-language-server"] = {},
                ["bash-language-server"] = {},
            }

            -- Ensure the servers and tools above are installed
            --
            -- To check the current status of installed tools and/or manually install
            -- other tools, you can run
            --    :Mason
            --
            -- You can press `g?` for help in this menu.
            --
            -- `mason` had to be setup earlier: to configure its options see the
            -- `dependencies` table for `nvim-lspconfig` above.
            --
            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "cspell",
                "stylua", -- Used to format Lua code
                "markdownlint-cli2",
                "eslint_d",
                "prettierd",
                "clang-format",
                "cpplint",
                "codelldb",
                "debugpy",
                "shfmt",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {}, -- explicitly set to an empty table (installation via mason-tool-installer)
                automatic_enable = true,
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })

            require("nvim-navic").setup({
                lsp = {
                    auto_attach = true,
                    preference = vim.tbl_keys(servers or {}),
                },
            })
        end,
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<CR>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<CR>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<CR>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<CR>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
            "davidmh/cspell.nvim",
        },
        main = "null-ls",
        opts = function()
            return {
                sources = {
                    -- Spelling
                    require("cspell").diagnostics.with({
                        diagnostics_postprocess = function(diagnostic)
                            diagnostic.severity = vim.diagnostic.severity.HINT
                        end,
                    }),
                    require("cspell").code_actions,

                    -- Markdown
                    require("null-ls").builtins.diagnostics.markdownlint_cli2,

                    -- JS/TS
                    require("none-ls.diagnostics.eslint_d"),
                    require("none-ls.code_actions.eslint_d"),
                    -- C/C++
                    require("none-ls.diagnostics.cpplint"),
                },
            }
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            formatters = {
                ["clang-format"] = {
                    args = { "--assume-filename", "$FILENAME", "--fallback-style", "Google" },
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                markdown = { "prettierd" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                rust = { lsp_format = "fallback" },
                sh = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 500,
            },
        },
        -- keys = {
        --     {
        --         "<leader>cf",
        --         function()
        --             require("conform").format({ async = true })
        --         end,
        --         desc = "Format Code",
        --     },
        -- },
    },
}

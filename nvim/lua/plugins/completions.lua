return {
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = "make install_jsregexp",
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {},
    },
    {
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "giuxtaposition/blink-cmp-copilot",
            "Kaiser-Yang/blink-cmp-avante",
        },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = "default" },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
                ghost_text = {
                    enabled = true,
                },
            },
            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "lazydev",
                    "copilot",
                    "avante",
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },
                },
            },
            snippets = { preset = "luasnip" },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
        },
    },
}

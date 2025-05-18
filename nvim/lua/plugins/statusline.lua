return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "AndreM222/copilot-lualine" },
        opts = {
            options = {
                theme = "catppuccin",
            },
            sections = {
                lualine_a = {
                    "mode",
                    {
                        require("noice").api.status.mode.get,
                        cond = require("noice").api.status.mode.has,
                    },
                },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    "filename",
                    {
                        require("noice").api.status.search.get,
                        cond = require("noice").api.status.search.has,
                        color = { fg = "#ff9e64" },
                    },
                },
                lualine_x = {
                    "diagnostics",
                    "lsp_status",
                    "copilot",
                },
                lualine_y = {
                    "filetype",
                    "encoding",
                    "fileformat",
                },
                lualine_z = { "progress", "location", "selectioncount" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        },
        config = function(_, opts)
            require("lualine").setup(opts)
            vim.opt.showmode = false
        end,
    },
}

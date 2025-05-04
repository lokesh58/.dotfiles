return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        theme = "catppuccin",
        sections = {
            lualine_b = { "branch", "diff", "lsp_status", "diagnostics" },
            lualine_x = {
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                    color = { fg = "#ff9e64" },
                },
                {
                    require("noice").api.status.search.get,
                    cond = require("noice").api.status.search.has,
                    color = { fg = "#ff9e64" },
                },
                "encoding",
                "fileformat",
                "filetype",
            },
        },
    },
    config = function(_, opts)
        require("lualine").setup(opts)
        vim.opt.showmode = false
    end,
}

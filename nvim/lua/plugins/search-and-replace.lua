return {
    {
        "MagicDuck/grug-far.nvim",
        opts = {},
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sr",
                function()
                    require("grug-far").open({ transient = true })
                end,
                mode = { "n", "x" },
                desc = "Search and replace",
            },
            {
                "<leader>sR",
                function()
                    require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } })
                end,
                mode = { "n", "x" },
                desc = "Search and replace in current file",
            },
            {
                "<leader>sw",
                function()
                    require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } })
                end,
                desc = "Search and replace for word under cursor",
            },
            {
                "<leader>sW",
                function()
                    require("grug-far").open({
                        transient = true,
                        prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%") },
                    })
                end,
                desc = "Search and replace for word under cursor in current file",
            },
            {
                "<leader>si",
                function()
                    require("grug-far").open({ transient = true, visualSelectionUsage = "operate-within-range" })
                end,
                mode = "x",
                desc = "Search and replace in visual selection",
            },
        },
    },
}

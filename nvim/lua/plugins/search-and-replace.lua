return {
    {
        "MagicDuck/grug-far.nvim",
        opts = {
            transient = true,
            windowCreationCommand = "topleft vsplit",
        },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sr",
                function()
                    require("grug-far").open()
                end,
                mode = { "n", "x" },
                desc = "Search and replace",
            },
            {
                "<leader>sR",
                function()
                    require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
                end,
                mode = { "n", "x" },
                desc = "Search and replace in current file",
            },
            {
                "<leader>sw",
                function()
                    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
                end,
                desc = "Search and replace for word under cursor",
            },
            {
                "<leader>sW",
                function()
                    require("grug-far").open({
                        prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%") },
                    })
                end,
                desc = "Search and replace for word under cursor in current file",
            },
            {
                "<leader>si",
                function()
                    require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
                end,
                mode = "x",
                desc = "Search and replace in visual selection",
            },
        },
    },
}

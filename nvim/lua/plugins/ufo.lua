return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
        provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
        end,
    },
    config = function(_, opts)
        require("ufo").setup(opts)
        vim.opt.foldcolumn = "1" -- '0' is not bad
        vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true
    end,
}

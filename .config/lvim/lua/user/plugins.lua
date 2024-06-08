lvim.plugins = {
    { "lunarvim/darkplus.nvim" },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        lazy = false,
        config = function()
            require("persistence").setup({
                dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
                options = { "buffers", "curdir", "tabpages", "winsize" },
            })
        end,
    },
    { "tobyS/vmustache" },
    { "tobyS/pdv" },
    { "SirVer/ultisnips" },
    { "mg979/vim-visual-multi" },
    { "hiphish/rainbow-delimiters.nvim" },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "simrat39/symbols-outline.nvim",
        config = function()
            require('symbols-outline').setup({
                autofold_depth = 2,
                width = 40,
                relative_width = false,
                auto_preview = false,
                position = "right",
            })
        end
    },
    { "MattesGroeger/vim-bookmarks" },
    { "tom-anders/telescope-vim-bookmarks.nvim" },
}

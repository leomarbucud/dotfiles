vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.softtabstop = 4
vim.opt.wrap = true
vim.opt.undofile = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- pdv php documentation adding comment blocks
local home = os.getenv('HOME')
vim.g.pdv_template_dir = home .. "/.local/share/lunarvim/site/pack/lazy/opt/pdv/templates_snip"

-- transparent window
lvim.transparent_window = true

-- show full path in searching file
lvim.builtin.telescope.defaults = {
	find_command = { "fd", "-t=f", "-a" },
	path_display = { shorten = 1 },
}

lvim.builtin.telescope.pickers.buffers.initial_mode = "insert"

-- bookmark options
vim.g.bookmark_save_per_working_dir = 1;
vim.g.bookmark_auto_save = 1;

-- auto fit file name in file view
lvim.builtin.nvimtree.setup.view.adaptive_size = true

-- fix error
lvim.builtin.treesitter.context_commentstring = nil

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        commonlisp = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
    blacklist = {'c', 'cpp'},
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "live_grep_args")
end

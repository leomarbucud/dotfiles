lvim.autocommands = {
    {
        "BufWinEnter",
        {
            pattern = { "*.yml", "*.yaml" },
            command = "set shiftwidth=4",
        }
    },
    {
        "BufRead",
        {
            pattern = { "*.conf" },
            command = "set ft=config",
        }
    },
    {
        "BufWinEnter",
        {
            command = "set nofixendofline"
        }
    }
}

local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end


require("conform").setup({
  formatters_by_ft = {
    php = { "php_cs_fixer" },
    -- twig = { "twig_cs_fixer" }
  },
    formatters = {

        twig_cs_fixer = {
            inherit = false,
            command = 'twig-cs-fixer',
            args = 'lint', '$FILENAME'
        }
    }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


return {
  "tobyS/pdv",
  dependencies = { "tobyS/vmustache", "SirVer/ultisnips" },
  lazy = false,
  config = function()
    local home = os.getenv('HOME')
    vim.g.pdv_template_dir = home .. "/.local/share/nvim/lazy/pdv/templates_snip"
  end,
}

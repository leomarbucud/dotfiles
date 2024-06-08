if not vim.g.neovide then
    return
end

vim.g.gui_font_default_size = 9
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "MesloLGS Nerd Font"

vim.g.neovide_transparency = 0.8

local refresh_gui_font = function()
    vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

local change_scale_factor = function(delta)
    vim.g.gui_font_size = vim.g.gui_font_size + delta
    refresh_gui_font()
end

vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1)
end)

vim.keymap.set("n", "<C-->", function()
    change_scale_factor(-1)
end)

refresh_gui_font()

-- ~/.config/nvim/lua/config/title.lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.opt.title = true
    vim.opt.titlestring = "NEOPENGUIN"
  end,
})

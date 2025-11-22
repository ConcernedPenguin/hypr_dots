-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.title = true
vim.opt.titlestring = "NEOPENGUIN"
vim.keymap.set("n", "<F5>", function()
  vim.cmd("w") -- save file
  vim.cmd("!gcc % -o %< && ./%<") -- compile & run
end)

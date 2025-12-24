-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--keymap for fix for lsp c code
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
--require('telescope.builtin').lsp_code_actions()

--for telescope search and browse
vim.keymap.set("n", "<leader>e", function()
  require("telescope").extensions.file_browser.file_browser({
    hidden = true,
    grouped = true,
    respect_gitignore = false,
  })
end, { noremap = true, silent = true, desc = "File Explorer" })

--for folder telescope
vim.keymap.set("n", "<leader>fp", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
  })
end, { desc = "Find files in project" })

-- Open terminal in a horizontal split
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>", { desc = "Open terminal" })

-- Toggle terminal in a floating window (requires nvim 0.8+)
vim.keymap.set("n", "<leader>tt", function()
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = "editor",
    width = 80,
    height = 20,
    row = 5,
    col = 10,
    style = "minimal",
  })
end, { desc = "Floating terminal" })

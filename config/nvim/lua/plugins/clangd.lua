return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "clangd" },
          filetypes = { "c", "cpp" },
        },
      },
    },
  },
}

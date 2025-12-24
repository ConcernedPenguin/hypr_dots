return {
  "nvim-telescope/telescope-file-browser.nvim",

  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },

  keys = {
    {
      "<leader>e",
      function()
        require("telescope").extensions.file_browser.file_browser({
          hidden = true,
          grouped = true,
          respect_gitignore = false,
        })
      end,
      desc = "File Explorer",
    },
  },

  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
      },
    })

    telescope.load_extension("file_browser")
  end,
}

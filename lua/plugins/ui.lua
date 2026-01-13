return {
  -- Icons (requires Nerd Font)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          telescope = true,
          treesitter = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}


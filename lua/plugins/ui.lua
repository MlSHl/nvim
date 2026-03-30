-- lua/plugins/ui.lua
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      term_colors = true,
      integrations = {
        telescope = true,
        treesitter = true,
      },
    },
    config = function(_, opts)
      vim.opt.termguicolors = true
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-nvim")
    end,
  },
}

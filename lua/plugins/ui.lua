-- lua/plugins/ui.lua
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true

      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          telescope = true,
          treesitter = true,
        },
	term_colors = true,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

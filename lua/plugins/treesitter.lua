return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "html",
          "css",
          "svelte",
          "c",
          "cpp",
          "rust",
          "python",
        },
        highlight = {
          enable = true,
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "svelte",
          "html",
          "css",
          "javascript",
          "typescript",
          "c",
          "cpp",
          "rust",
          "python",
        },
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
  },
}

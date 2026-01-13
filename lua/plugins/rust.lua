return {
  -- Installer UI
  { "williamboman/mason.nvim", config = true },

  -- Optional: auto-install rust-analyzer via mason
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = { ensure_installed = { "rust_analyzer" } },
  },

  -- Neovim 0.11+ native LSP config (NO require('lspconfig'))
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      -- Capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- If you install rust-analyzer via Mason, this path usually works:
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"

      -- Define/extend the config (Neovim 0.11+)
      vim.lsp.config("rust_analyzer", {
        cmd = (vim.uv.fs_stat(mason_bin) and { mason_bin }) or { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      })

      -- Enable it
      vim.lsp.enable("rust_analyzer")

      -- Format on save for Rust buffers
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- Completion (keep your existing nvim-cmp block, or use the one below)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
}


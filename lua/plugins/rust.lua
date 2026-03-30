return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
    local ra_cmd = (vim.uv.fs_stat(mason_bin) and { mason_bin }) or { "rust-analyzer" }

    vim.g.rustaceanvim = {
      server = {
        cmd = ra_cmd,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
            checkOnSave = false,
          },
        },
      },
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
}

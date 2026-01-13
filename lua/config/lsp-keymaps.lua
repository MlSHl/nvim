vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }

    -- IDE-like LSP actions
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
      vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code action" }))

    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
      vim.tbl_extend("force", opts, { desc = "Go to definition" }))

    vim.keymap.set("n", "gr", vim.lsp.buf.references,
      vim.tbl_extend("force", opts, { desc = "Find references" }))

    vim.keymap.set("n", "K", vim.lsp.buf.hover,
      vim.tbl_extend("force", opts, { desc = "Hover docs" }))
  end,
})


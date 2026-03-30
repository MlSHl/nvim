return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local cmp = require("cmp")

    cmp.setup({
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-x><C-o>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
        }),
    })
    end,
    },
}

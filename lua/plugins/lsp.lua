-- lua/plugins/lsp.lua
return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
        opts = {
			ensure_installed = {
				"lua_ls",
				"svelte",
				"ts_ls",
				"html",
				"cssls",
				"pyright",
			},
			automatic_enable = {
				exclude = { "rust_analyzer" },
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
				svelte = {},
				ts_ls = {},
				html = {},
				cssls = {},
				pyright = {},
			}

			for name, server_opts in pairs(servers) do
				server_opts.capabilities = capabilities
				vim.lsp.config(name, server_opts)
			end
		end,
	},
}

return require('lazy').setup({

    -- === CORE TOOLS AND MANAGEMENT ===

    -- 1. Mason: LSP/Tool Manager
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            -- Ensure clangd, codelldb, and clang-format are installed automatically
            ensure_installed = {
                "clangd",        -- C/C++ Language Server
                "codelldb",      -- Debug Adapter for C/C++
                "clang-format",  -- Formatter
            },
        },
        config = function()
            require("mason").setup()
        end,
    },

    -- 2. Treesitter plugin for better syntax highlighting (Now includes CUDA)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                -- IMPORTANT: Added "cuda" parser
                ensure_installed = { "lua", "python", "c", "cpp", "cuda" },
                highlight = {
                    enable = true,
                },
            }
            -- Manually associate .cu and .cuh files with the CUDA parser
            vim.filetype.add({
                extension = {
                    cu = "cuda",
                    cuh = "cuda",
                }
            })
        end,
    },

    -- === C++/CUDA LSP & AUTOCOMPLETION ===

    -- 3. LSP Configuration (clangd)
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp", -- For autocompletion integration
        },
        config = function()
            local on_attach = function(client, bufnr)
                -- Optional: Auto-format C/C++ files on save using clang-format
                if client.name == "clangd" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end

            -- Set up automatic LSP installation and configuration via handlers
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                automatic_setup = true,
                handlers = {
                    -- Default handler for all servers not explicitly listed below
                    function(server_name)
                        require("lspconfig")[server_name].setup({ on_attach = on_attach })
                    end,

                    -- Explicit handler for clangd with CUDA configuration
                    clangd = function()
                        require("lspconfig").clangd.setup({
                            on_attach = on_attach,
                            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                            cmd = {
                                "clangd",
                                "--background-index",
                                "--completion-style=detailed",
                                "--function-arg-placeholders",
                                -- *** CUDA-SPECIFIC FLAGS ***
                                "-xcuda",
                                "--cuda-gpu-arch=sm_89", -- Adjust this for your GPU architecture
                                "--cuda-path=/usr/local/cuda", -- Adjust this to your CUDA toolkit path
                            },
                        })
                    end,
                },
            })
        end,
    },

    -- 4. Autocompletion Engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP source
            "hrsh7th/cmp-buffer",   -- Buffer source
            "L3MON4D3/LuaSnip",     -- Snippet engine
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
                -- Add keymaps for completion here
            })
        end,
    },

    --- === DEBUGGING (DAP) ===

    -- 5. DAP UI (Must be configured before nvim-dap uses it)
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { 
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio", -- *** NEW DEPENDENCY ADDED HERE ***
        },
        config = function()
            local dapui = require("dapui")
            dapui.setup()

            -- Set up DAP UI listeners
            local dap = require("dap")
            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
            end
        end,
    },

    -- 6. DAP Core Logic
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Configure the codelldb adapter (installed via Mason)
            dap.adapters.codelldb = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                },
            }

            -- Set up C++ (and CUDA) launch configuration
            dap.configurations.cpp = {
                {
                    name = "Launch C++/CUDA Executable",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp
        end,
    },

    -- === MISC UI/UX PLUGINS (Existing) ===

    -- Lualine plugin for a status line
    { "nvim-lualine/lualine.nvim" },

    -- File explorer plugin
    { "nvim-tree/nvim-tree.lua" },

    -- Telescope for fuzzy finding
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    lualine = true,
                    telescope = true,
                },
                custom_highlights = {
                    Normal = { fg = "#d9a0a0", bg = "#1e1e2e" },
                },
            })
            vim.cmd("colorscheme catppuccin")
        end
    }
})

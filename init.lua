-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key
vim.g.mapleader = " "

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Load plugins
require("plugins")

-- Apply colorscheme after plugin loading
vim.cmd("colorscheme catppuccin")

-- Keymap example
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Open file explorer (e.g., nvim-tree or netrw)

-- Make background transparent / match terminal
 vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
 vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])


-- disable netrw (nvim-tree conflicts)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- install lazy.nvim if it doesn't exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('leader') -- this must be first according to lazy.nvim's docs
require('lazy').setup('plugins')
require('settings')
require('theme')
require('mappings')
require('lsp')
require('treesitter')
require('search')
require('git')
require('sidebars')
require('golang')
require('java')

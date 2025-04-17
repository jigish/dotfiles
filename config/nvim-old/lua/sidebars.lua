-- nvim-tree
require('nvim-tree').setup({
  sort = {
    sorter = 'case_sensitive',
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.keymap.set('n', '<leader>T', '<cmd>NvimTreeToggle<CR>')

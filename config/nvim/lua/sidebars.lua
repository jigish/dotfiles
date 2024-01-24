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

-- aerial
require('aerial').setup({
  layout = {
    default_direction = 'left',
  },
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
})
vim.keymap.set('n', '<leader>O', '<cmd>AerialToggle<CR>')

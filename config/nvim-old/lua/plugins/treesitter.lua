return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        require('nvim-treesitter.install').update({ with_sync = true })()
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
}

return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('nord').setup({})
      --vim.opt.background = 'dark'
      --vim.g.constrast = true
      vim.cmd.colorscheme('nord')
    end,
  },
}

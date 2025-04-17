return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.g.constrast = true
      vim.cmd.colorscheme('nord')
    end,
  },
}

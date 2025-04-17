return {
  { 'linrongbin16/lsp-progress.nvim', opts = {} },
  { "chrisgrieser/nvim-dr-lsp", opts = {} },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'echasnovski/mini.icons',
      "chrisgrieser/nvim-dr-lsp",
      'linrongbin16/lsp-progress.nvim',
    },
    opts = {
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          'filename',
          function()
            return require("dr-lsp").lspCount()
          end,
          function()
            return require('lsp-progress').progress()
          end,
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      options = {
        theme = 'nord'
      },
    },
  },
}

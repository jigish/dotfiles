-- golang specific settings
local go_settings_group = vim.api.nvim_create_augroup('golang', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*.go',
  group = go_settings_group,
  callback = function() vim.opt_local.expandtab = false end,
})

-- Run gofmt + goimport on save
local go_fmt_group = vim.api.nvim_create_augroup('GoImport', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
   require('go.format').goimport()
  end,
  group = go_fmt_group,
})

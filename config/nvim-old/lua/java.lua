-- java specific settings
local javagroup = vim.api.nvim_create_augroup('java', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*.java',
  group = javagroup,
  callback = function() vim.opt_local.tabstop = 4 end,
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*.java',
  group = javagroup,
  callback = function() vim.opt_local.softtabstop = 4 end,
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*.java',
  group = javagroup,
  callback = function() vim.opt_local.shiftwidth = 4 end,
})

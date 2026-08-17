vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.gotmpl"] = "helm",
    [".*/templates/.*%.tmpl"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'c',
    'cpp',
    'cs',
    'go',
    'h',
    'helm',
    'java',
    'js',
    'json',
    'md',
    'proto',
    'py',
    'pyi',
    'rb',
    'rs',
    'ts',
    'yaml',
    'zed',
  },
  callback = function() vim.treesitter.start() end,
})

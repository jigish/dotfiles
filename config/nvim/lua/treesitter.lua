require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'diff',
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'ini',
    'json',
    'jsonnet',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'rust',
    'sql',
    'strace',
    'toml',
    'vim',
    'vimdoc',
    'yaml',
  },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'c_sharp',
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'hcl',
    'html',
    'http',
    'ini',
    'javascript',
    'json',
    'jsonnet',
    'just',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'ruby',
    'rust',
    'scss',
    'sql',
    'strace',
    'terraform',
    'toml',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
    'zig',
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

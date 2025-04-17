return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    keymap = { preset = 'default' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = { documentation = { auto_show = false } },
    fuzzy = { implementation = "rust" },
  },
  opts_extend = { "sources.default" },
}

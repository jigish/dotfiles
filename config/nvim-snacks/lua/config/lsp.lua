-- listen to lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})

require("tiny-inline-diagnostic").setup({
  preset = "powerline",
  options = {
    add_messages = {
      display_count = true,
    },
    multilines = {
      enabled = true,
    },
    show_source = {
      enabled = true,
    },
  },
})

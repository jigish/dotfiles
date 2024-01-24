-- color scheme
vim.opt.background = 'dark'
vim.g.contrast = true
require('nord').set()
local colors = require('nord.named_colors')

-- lualine
require('lualine').setup({
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', require("dr-lsp").lspCount, require('lsp-progress').progress},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  options = {
    theme = 'nord'
  }
})
-- listen to lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})

-- quick fix window
require('pqf').setup({
  signs = {
    error = ' ',
    warning = ' ',
    info = ' ',
    hint = '󰌶 '
  },
  show_multiple_lines = false,
  max_filename_length = 0,
})

-- gutter signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- show extra whitespace
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = colors.red })
vim.cmd.match({ 'ExtraWhitespace', '/\\s\\+$/' })
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  pattern = '*',
  callback = function() vim.cmd.match({ 'ExtraWhitespace', '/\\s\\+$/' }) end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  callback = function() vim.cmd.match({ 'ExtraWhitespace', '/\\s\\+\\%#\\@<!$/' }) end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  pattern = '*',
  callback = function() vim.cmd.match({ 'ExtraWhitespace', '/\\s\\+$/' }) end,
})
vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  pattern = '*',
  callback = function() vim.fn.clearmatches() end,
})

-- color column
local function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
vim.api.nvim_create_user_command('ToggleColorColumn',
  function()
    if has_value(vim.opt.colorcolumn:get(), '+0') then
      vim.opt.colorcolumn:remove({ '+0' })
    else
      vim.opt.colorcolumn:append({ '+0' })
    end
  end,
  {})
vim.cmd.ToggleColorColumn()

-- headlines config
require("headlines").setup({
    markdown = {
        headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
        },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        quote_highlight = "Quote",
    },
})

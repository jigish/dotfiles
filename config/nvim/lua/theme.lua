-- color scheme
vim.opt.background = 'dark'
vim.g.contrast = true
require('nord').set()
local colors = require('nord.named_colors')

-- lualine
require('lualine').setup({
  options = {
    theme = 'nord'
  }
})

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
    for index, value in ipairs(tab) do
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

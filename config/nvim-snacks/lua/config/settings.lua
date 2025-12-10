HOME = os.getenv('HOME')

-- basic configurations ---------------------------------------------------------

-- tmp file directories
vim.opt.backupdir = HOME .. '/.config/nvim/tmp/backup'
vim.opt.dir = HOME .. '/.config/nvim/tmp/swap'
vim.opt.undodir = HOME .. '/.config/nvim/tmp/undo'
vim.opt.undofile = true

-- completion and tags
vim.opt.completeopt:remove { 'preview' }
vim.opt.tags:append { '.tags' }
vim.opt.wildmode = 'list:longest,full'

-- formatting
vim.opt.formatoptions:append { r = true, o = true, l = true }

-- buffers
vim.opt.hidden = true

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true -- override ignorecase if search contains uppers

-- spell check is annoying
vim.opt.spell = false

-- appearance
--vim.opt.linespace = 1 -- add space between lines
vim.opt.title = true
vim.opt.termguicolors = true

-- tabs and returns
vim.opt.expandtab = true -- by default expand tabs to spaces
vim.opt.list = true -- show tabs and returns
vim.opt.listchars = { tab = '▸ ', eol = '¬' } -- set tab/return characters
vim.opt.smartindent = true -- enable smart tabbing
vim.opt.tabstop = 2 -- tabs are 2 spaces
vim.opt.softtabstop = 2 -- tabs are 2 spaces
vim.opt.shiftwidth = 2 -- tabs are 2 spaces

-- no bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- line numbers, width, and scrolling
vim.opt.number = true -- line numbers
vim.opt.textwidth = 120
vim.opt.wrapmargin = 120
vim.opt.scrolloff = 3 -- 3 lines ahead of cursor for scrolling

-- messages
vim.opt.shortmess = { a = true, t = true, I = true }

-- splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- key code sequences
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 0

-- terminal stuff
vim.g.terminal_scrollback_buffer_size = 2147483647 -- set terminal history super long

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
    if has_value(vim.opt.colorcolumn:get(), '+1') then
      vim.opt.colorcolumn:remove({ '+1' })
    else
      vim.opt.colorcolumn:append({ '+1' })
    end
  end,
  {})
vim.cmd.ToggleColorColumn()

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

-- no squiggly
local hl_groups = { 'DiagnosticUnderlineError' }
for _, hl in ipairs(hl_groups) do
  vim.cmd.highlight(hl .. ' gui=underline')
end

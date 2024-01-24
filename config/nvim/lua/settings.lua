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
vim.opt.textwidth = 135
vim.opt.wrapmargin = 135
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

-- auto-open quick fix window on make and such. not sure if this is needed in neovim so it is commented out for now.
-- vim.api.vim_create_autocmd({ 'QuickFixCmdPost' }, {
--   pattern = '[^l]*',
--   command = 'nested cwindow',
-- })
-- vim.api.vim_create_autocmd({ 'QuickFixCmdPost' }, {
--   pattern = 'l*',
--   command = 'nested lwindow',
-- })

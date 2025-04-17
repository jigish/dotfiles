-- my fingers are slow. bind :W to :w, :Q to :q, :Wq to :wq, and :Wa to :wa
-- TODO figure out a way to luaify this
vim.cmd([[
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
cnoreabbrev <expr> Wa ((getcmdtype() is# ':' && getcmdline() is# 'Wa')?('wa'):('Wa'))
]])

-- remap s and S to be more useful (split lines)
vim.keymap.set('n', 's', 'i<CR><ESC>==')
vim.keymap.set('n', 'S', 'd$O<ESC>p==')

-- yank to and paste from clipboard
vim.keymap.set('v', '<leader>yc', '"*y')
vim.keymap.set('n', '<leader>yp', '"*p')

-- delete trailing whitespace
vim.api.nvim_create_user_command('DeleteTrailingWhitespace', '%s:\\(\\S*\\)\\s\\+$:\\1:', {})
vim.keymap.set('n', '<leader><F6>', '<cmd>DeleteTrailingWhitespace<CR>')

-- buffer management
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>')
vim.keymap.set('n', '<leader>bD', '<cmd>bdelete!<CR>')
vim.keymap.set('n', '<leader>fD', '<cmd>call delete(@%)<CR><cmd>bdelete!<CR>')

-- splitting
vim.keymap.set('t', '<M-c>', '<C-\\><C-n>')
vim.keymap.set('t', '<M-x>', '<C-\\><C-n>')
vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set('n', '<M-h>', '<C-w>h')
vim.keymap.set('n', '<M-j>', '<C-w>j')
vim.keymap.set('n', '<M-k>', '<C-w>k')
vim.keymap.set('n', '<M-l>', '<C-w>l')
vim.keymap.set('n', '<M-d>', ':vsplit<CR>')
vim.keymap.set('n', '<M-D>', ':split<CR>')
vim.keymap.set('t', '<M-d>', '<C-\\><C-n>:vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<M-T>', '<C-\\><C-n>:split<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('n', '<M-t>', ':vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('n', '<M-T>', ':split<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<M-t>', '<C-\\><C-n>:vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<M-T>', '<C-\\><C-n>:split<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<A-c>', '<C-\\><C-n>')
vim.keymap.set('t', '<A-x>', '<C-\\><C-n>')
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<A-d>', ':vsplit<CR>')
vim.keymap.set('n', '<A-D>', ':split<CR>')
vim.keymap.set('t', '<A-d>', '<C-\\><C-n>:vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<A-T>', '<C-\\><C-n>:split<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('n', '<A-t>', ':vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('n', '<A-T>', ':split<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<A-t>', '<C-\\><C-n>:vsplit<CR>:terminal<CR>:set nonumber<CR>')
vim.keymap.set('t', '<A-T>', '<C-\\><C-n>:split<CR>:terminal<CR>:set nonumber<CR>')

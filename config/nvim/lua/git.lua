-- gitsigns
require('gitsigns').setup()

-- fugitive mappings
vim.keymap.set('n', '<leader>gs', ':Git<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gP', ':Git pull<CR>')
vim.keymap.set('n', '<leader>gl', ':Git pull<CR>')
vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>')
vim.keymap.set({'n', 'v'}, '<leader>dp', ':diffput<CR>')
vim.keymap.set({'n', 'v'}, '<leader>dg', ':diffget<CR>')
vim.keymap.set({'n', 'v'}, '<leader>gb', ':Git blame<CR>')
vim.keymap.set('n', '<leader>ga', ':Git add .<CR>')
vim.keymap.set('n', '<leader>gr', ':!gpr<CR>')
vim.keymap.set('n', '<leader>gD', '<C-w>h<C-w>c')

-- gv mappings
vim.keymap.set('n', '<leader>gv', ':GV!<CR>') -- commits for current file
vim.keymap.set('n', '<leader>gV', ':GV<CR>') -- all commits

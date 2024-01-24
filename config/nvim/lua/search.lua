-- telescope
require('telescope').load_extension('fzf')
-- ctrl-p style mappings
vim.keymap.set('n', '<C-p>', ':lua require("telescope.builtin").find_files()<CR>')
vim.keymap.set('n', '<C-g>', ':lua require("telescope.builtin").git_files()<CR>')
vim.keymap.set('n', '<C-b>', ':lua require("telescope.builtin").buffers()<CR>')
vim.keymap.set('n', '<C-l>', ':lua require("telescope.builtin").live_grep()<CR>')

-- grepper
vim.keymap.set('', '<leader>aw', ':lua require("telescope.builtin").grep_string()<CR>')
vim.keymap.set('', '<leader>rw', ':lua require("telescope.builtin").lsp_references()<CR>')
vim.keymap.set('', '<leader>iw', ':lua require("telescope.builtin").lsp_implementations()<CR>')
vim.keymap.set('', '<leader>dw', ':lua require("telescope.builtin").lsp_definitions()<CR>')
vim.keymap.set('', '<leader>tw', ':lua require("telescope.builtin").lsp_type_definitions()<CR>')

-- telescope
require('telescope').load_extension('fzy_native')
-- ctrl-p style mappings
vim.keymap.set('n', '<C-p>', ':lua require("telescope.builtin").find_files()<CR>')
vim.keymap.set('n', '<C-g>', ':lua require("telescope.builtin").git_files()<CR>')
vim.keymap.set('n', '<C-b>', ':lua require("telescope.builtin").buffers()<CR>')
vim.keymap.set('n', '<C-l>', ':lua require("telescope.builtin").live_grep()<CR>')
vim.keymap.set('n', '<leader>aa', ':lua require("telescope.builtin").live_grep()<CR>')
-- grepper style mappings
vim.keymap.set('', '<leader>aw', ':lua require("telescope.builtin").grep_string()<CR>')
vim.keymap.set('', '<leader>rw', ':lua require("telescope.builtin").lsp_references()<CR>')
vim.keymap.set('', '<leader>iw', ':lua require("telescope.builtin").lsp_implementations()<CR>')
vim.keymap.set('', '<leader>dw', ':lua require("telescope.builtin").lsp_definitions()<CR>')
vim.keymap.set('', '<leader>tw', ':lua require("telescope.builtin").lsp_type_definitions()<CR>')

-- spectre
require('spectre').setup()
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

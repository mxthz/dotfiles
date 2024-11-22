local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>f', ':FzfLua files<CR>', opts)
vim.keymap.set('n', '<leader>g', ':FzfLua grep<CR>', opts)
vim.keymap.set('n', '<leader>;', ':FzfLua buffers<CR>', opts)

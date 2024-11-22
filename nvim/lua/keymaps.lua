local opts = { silent = true, noremap = true }

-- Leader key
vim.g.mapleader = ','
-- highlights
vim.keymap.set('n', '<leader>h', ':set hls!<CR>', opts)
-- remap capital W command to lowercase (save) w
vim.cmd('command! W w')

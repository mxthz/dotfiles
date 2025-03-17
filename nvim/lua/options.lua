local set = vim.o

-- Line indicators
set.number = true
set.relativenumber = true
set.cursorline = true

-- Tab settings
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.autoindent = true
set.smartindent = true

-- Split
set.splitbelow = true
set.splitright = true

-- Keep undo files
set.undofile = true
set.undodir = vim.fn.expand "~/.undofiles"

-- Remove backup and swap files
set.backup = false
set.swapfile = false

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.arb",
  command = "set filetype=json"
})

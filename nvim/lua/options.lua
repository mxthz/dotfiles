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

-- Split
set.splitbelow = true
set.splitright = true

---- removes cursorline (keep only line number highlight)
--vim.cmd([[ hi CursorLine gui=NONE ]])

-- Keep undo files on RAM
set.undofile = true
set.undodir = vim.fn.expand "~/.undofiles"

-- Remove backup and swap files
set.backup = false
set.swapfile = false

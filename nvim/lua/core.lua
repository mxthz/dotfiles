local set = vim.o
local opts = { silent = true, noremap = true }

-- =============================================================================
--                                     THEME
-- =============================================================================
vim.g.colors_name = "dracula"
vim.cmd("colorscheme dracula")
vim.cmd(":highlight Normal ctermbg=black")

-- =============================================================================
--                                   SETTINGS
-- =============================================================================
-- Line indicators
set.number = true
set.relativenumber = true
set.cursorline = true

-- Indentation
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.autoindent = true
set.smartindent = true

-- Window split
set.splitbelow = true
set.splitright = true

-- Keep undo files
set.undofile = true
set.undodir = vim.fn.expand("~/.undofiles")

-- Remove backup and swap files
set.backup = false
set.swapfile = false

-- =============================================================================
--                                    KEYMAPS
-- =============================================================================
-- Leader key
vim.g.mapleader = ","
-- Highlights
vim.keymap.set("n", "<leader>h", ":set hls!<CR>", opts)
-- Remap capital W command to lowercase (save) w
vim.cmd("command! W w")
vim.keymap.set("n", "<leader>;", "<C-^>", opts)

-- =============================================================================
--                                   COMMANDS
-- =============================================================================
-- Read .arb files as json
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.arb",
	command = "set filetype=json",
})

-- Reload and attach LSP client
vim.api.nvim_create_user_command("Reload", function()
	vim.cmd("e!")
	vim.lsp.buf_attach_client(0, vim.lsp.get_active_clients()[1].id)
end, {})

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
	vim.lsp.buf_attach_client(0, vim.lsp.get_clients()[1].id)
end, {})

-- Properly detach LSP clients when closing a buffer
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		local bufnr = args.buf
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		for _, client in ipairs(clients) do
			vim.lsp.buf_detach_client(bufnr, client.id)
		end
	end,
	group = vim.api.nvim_create_augroup("LSPDetachBeforeDelete", {}),
})

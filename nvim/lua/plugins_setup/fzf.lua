local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
	actions = {
		files = {
			true,
			["ctrl-q"] = actions.file_sel_to_qf,
		},
		diagnostics = {
			true,
			["ctrl-q"] = actions.file_sel_to_qf,
		},
	},
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", ":FzfLua diagnostics_workspace<CR>", opts)
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", opts)
vim.keymap.set("n", "<leader>g", ":FzfLua grep<CR>", opts)
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", opts)

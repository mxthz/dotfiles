vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>b", ":Oil<CR>",
  { desc = "Open Oil floating window", silent = true, noremap = true, })

require("oil").setup({
  default_file_explorer = true,
})

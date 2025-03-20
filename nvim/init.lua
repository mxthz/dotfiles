-- CORE
require("colorscheme")
require("options")
require("keymaps")
require("scripts/comment-header")
-- PLUGINS
require("plugins")
--Configs
require("config/lsp")
require("config/none-ls")
require("config/treesitter")
require("config/fzf")
require("config/cmp")
require("config/flutter-tools")
require("config/oil")

require("nvim-autopairs").setup({})

vim.api.nvim_create_user_command("Reload", function()
	vim.cmd("e!")
	vim.lsp.buf_attach_client(0, vim.lsp.get_active_clients()[1].id)
end, {})

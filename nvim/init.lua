-- CORE
require("colorscheme")
require("options")
require("keymaps")
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

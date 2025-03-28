-- =============================================================================
--                                     CORE
-- =============================================================================
require("core")
require("custom_scripts.comment-header")

-- =============================================================================
--                                    PLUGINS
-- =============================================================================
require("plugins")

--Configs
require("plugins_setup.lsp")
require("plugins_setup.none-ls")
require("plugins_setup.treesitter")
require("plugins_setup.fzf")
require("plugins_setup.cmp")
require("plugins_setup.flutter-tools")
require("plugins_setup.oil")

require("nvim-autopairs").setup({})

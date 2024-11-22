require "flutter-tools".setup {
  lsp = {
      on_attach = require("config/lsp").on_attach,
  },
  closing_tags = {
    enabled = true
  },
  widget_guides = {
    enabled = true,
  },
  decorations = {
    statusline = {
      app_version = true,
      device = true,
    }
  },
}

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<space>fS", string.format(":FlutterRun --dart-define MAPBOX_TOKEN=%s -d iPhone<CR>", require("secrets").MAPBOX), opts)
vim.keymap.set("n", "<space>fr", ":FlutterReload<CR>", opts)
vim.keymap.set("n", "<space>fR", ":FlutterRestart<CR>", opts)
vim.keymap.set("n", "<space>fd", ":FlutterOpenDevTools<CR>", opts)
vim.keymap.set("n", "<space>fc", ":FlutterLogClear<CR>", opts)
vim.keymap.set("n", "<space>fQ", ":FlutterQuit<CR>", opts)

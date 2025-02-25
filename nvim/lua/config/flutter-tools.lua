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

local function getRunCommand(device)
  return string.format(":FlutterRun --dart-define MAPBOX_TOKEN=%s -d %s<CR>", require("secrets").MAPBOX_TOKEN, device)
end

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<space>fi", getRunCommand("iPhone"), opts)
vim.keymap.set("n", "<space>fa", getRunCommand("sdk"), opts)
vim.keymap.set("n", "<space>fr", ":FlutterReload<CR>", opts)
vim.keymap.set("n", "<space>fR", ":FlutterRestart<CR>", opts)
vim.keymap.set("n", "<space>fd", ":FlutterDevices<CR>", { noremap = true })
vim.keymap.set("n", "<space>fe", ":FlutterEmulators<CR>", { noremap = true })
vim.keymap.set("n", "<space>fy", ":FlutterCopyProfilerUrl<CR>", { noremap = true })
vim.keymap.set("n", "<space>fl", ":FlutterLogToggle<CR>", opts)
vim.keymap.set("n", "<space>fo", ":FlutterOutlineToggle<CR>", opts)
vim.keymap.set("n", "<space>fc", ":FlutterLogClear<CR>", opts)
vim.keymap.set("n", "<space>fQ", ":FlutterQuit<CR>", opts)

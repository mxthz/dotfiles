require("flutter-tools").setup({
	lsp = {
		on_attach = require("plugins_setup.lsp").on_attach,
	},
	closing_tags = {
		enabled = true,
	},
	widget_guides = {
		enabled = true,
	},
	decorations = {
		statusline = {
			app_version = true,
			device = true,
		},
	},
})

local function getLocalIp()
	local handle = io.popen("echo $(ipconfig getifaddr en0)")
	if not handle then
		return "127.0.0.1"
	end
	local ip = handle:read("*a")
	handle:close()
	-- Remove any leading/trailing whitespace
	ip = ip:match("^(%S+)")
	return ip
end

local localIp = getLocalIp()
local mapboxToken = require("secrets").MAPBOX_TOKEN
local function getRunCommand()
	return string.format(
		":FlutterRun --dart-define MAPBOX_TOKEN=%s --dart-define LOCAL_IP=%s -d ",
		mapboxToken,
		localIp
	)
end

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<space>fs", getRunCommand(), { noremap = true })
vim.keymap.set("n", "<space>fr", ":FlutterReload<CR>", opts)
vim.keymap.set("n", "<space>fR", ":FlutterRestart<CR>", opts)
vim.keymap.set("n", "<space>fd", ":FlutterDevices<CR>", { noremap = true })
vim.keymap.set("n", "<space>fe", ":FlutterEmulators<CR>", { noremap = true })
vim.keymap.set("n", "<space>fy", ":FlutterCopyProfilerUrl<CR>", { noremap = true })
vim.keymap.set("n", "<space>fl", ":FlutterLogToggle<CR>", opts)
vim.keymap.set("n", "<space>fo", ":FlutterOutlineToggle<CR>", opts)
vim.keymap.set("n", "<space>fc", ":FlutterLogClear<CR>", opts)
vim.keymap.set("n", "<space>fQ", ":FlutterQuit<CR>", opts)

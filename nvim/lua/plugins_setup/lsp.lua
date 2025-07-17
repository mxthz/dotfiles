-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gR", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gx", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("v", "gx", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	-- "vim.lsp.buf.formatting" was default
	-- but flutter-tools conflicts and prompt to choose a server while formatting
	-- so I'm running both sequencially
	vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)

	vim.diagnostic.config({
		virtual_text = true,
	})

	--Inlay hints
	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

require("mason").setup()
local lspconfig = require("lspconfig")

-- A list of servers to install and configure
local servers = {
	"lua_ls",
	"denols",
	"jsonls",
}

-- Ensure these servers are installed by Mason
require("mason-lspconfig").setup({
	ensure_installed = servers,
})

for _, server_name in ipairs(servers) do
	local server_opts = {
		-- This is the crucial part: we pass our on_attach to every server.
		on_attach = on_attach,
	}

	--   Server-specific overrides
	if server_name == "denols" then
		server_opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
	end

	lspconfig[server_name].setup(server_opts)
end

local module = {
	on_attach = on_attach,
}

return module

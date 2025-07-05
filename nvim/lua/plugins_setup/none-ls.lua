local null_ls = require("null-ls")
local lSsources = {
	--FORMATTING
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.stylelint,
	null_ls.builtins.formatting.shellharden,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.pg_format,
	null_ls.builtins.formatting.dart_format,
	-- DIAGNOSTICS
	null_ls.builtins.diagnostics.stylelint,
}

require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
	sources = lSsources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(c)
							return c.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})

local null_ls = require("null-ls")

local lSsources = {
	-- FORMATTING
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

require("null-ls").setup({
	sources = lSsources,
})

-- Create a custom command 'W' to format the current buffer and then save it.
vim.api.nvim_create_user_command("W", function()
	-- Format the buffer using only null-ls sources.
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		-- Using async = false ensures formatting completes before saving.
		async = false,
	})
	-- Write (save) the file after formatting is complete.
	vim.cmd("w")
end, {})

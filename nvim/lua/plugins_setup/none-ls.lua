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
	-- TypeScript/JavaScript linting (disabled if using eslint LSP)
	-- null_ls.builtins.diagnostics.eslint_d,
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

-- Create a custom command 'Wq' to format, save, and quit
vim.api.nvim_create_user_command("Wq", function()
	-- Format the buffer using only null-ls sources.
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		async = false,
	})
	-- Write and quit after formatting is complete.
	vim.cmd("wq")
end, {})

-- Create a custom command 'Wa' to format current buffer and save all
vim.api.nvim_create_user_command("Wa", function()
	-- Format the current buffer using only null-ls sources.
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		async = false,
	})
	-- Write all files after formatting is complete.
	vim.cmd("wa")
end, {})

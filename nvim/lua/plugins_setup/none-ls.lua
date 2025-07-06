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

-- Setup null-ls without the on_attach function to disable automatic format-on-save.
require("null-ls").setup({
	should_attach = function(bufnr)
		-- Check if a deno.json file exists in the project root.
		local is_deno_project =
			require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(vim.api.nvim_buf_get_name(bufnr))

		if is_deno_project then
			-- If we are in a Deno project, DO NOT attach none-ls.
			vim.notify("[none-ls] Skipping attach in Deno project.", vim.log.levels.INFO)
			return false
		end

		-- Otherwise, it's safe to attach none-ls.
		return true
	end,
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

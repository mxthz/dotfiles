local present, copilot = pcall(require, "copilot")

if not present then
	return
end

copilot.setup({
	suggestion = {
		enabled = false,  -- Disable inline suggestions when using cmp
		auto_trigger = false,
	},
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "[",
			jump_next = "]",
			accept = "<CR>",
			refresh = "=",
			open = "<M-CR>",
		},
	},
})

-- Setup copilot-cmp to integrate with nvim-cmp
local present2, copilot_cmp = pcall(require, "copilot_cmp")

if present2 then
	copilot_cmp.setup({
		method = "getCompletionsCycling",
		formatters = {
			label = require("copilot_cmp.format").format_label,
			insert_text = require("copilot_cmp.format").format_insert_text,
			preview = require("copilot_cmp.format").format_preview,
		},
	})
end

-- Additional Copilot configuration
local group = vim.api.nvim_create_augroup("CopilotConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-panel",
	group = group,
	callback = function()
		vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true, silent = true })
		vim.keymap.set("n", "<CR>", "<Cmd>lua require('copilot.panel').accept()<CR>", { buffer = true, silent = true })
		vim.keymap.set(
			"n",
			"o",
			"<Cmd>lua require('copilot.panel').accept_and_reject_all()<CR>",
			{ buffer = true, silent = true }
		)
		vim.keymap.set("n", "[", "<Cmd>lua require('copilot.panel').prev()<CR>", { buffer = true, silent = true })
		vim.keymap.set("n", "]", "<Cmd>lua require('copilot.panel').next()<CR>", { buffer = true, silent = true })
	end,
})

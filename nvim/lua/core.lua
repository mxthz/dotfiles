local set = vim.o
local opts = { silent = true, noremap = true }

-- =============================================================================
--                                   SETTINGS
-- =============================================================================
-- Line indicators
set.number = true
set.relativenumber = true
set.cursorline = true

-- Indentation
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.autoindent = true
set.smartindent = true

-- Window split
set.splitbelow = true
set.splitright = true

-- Keep undo files
set.undofile = true
set.undodir = vim.fn.expand("~/.undofiles")

-- Remove backup and swap files
set.backup = false
set.swapfile = false

-- Auto-reload buffers when files change on disk
set.autoread = true
-- Trigger autoread on specific events
vim.api.nvim_create_autocmd({
	"BufEnter",
	"CursorHold",
	"CursorHoldI",
	"FocusGained",
}, {
	command = "checktime",
})

-- =============================================================================
--                                    KEYMAPS
-- =============================================================================
-- Leader key
vim.g.mapleader = ","
-- Highlights
vim.keymap.set("n", "<leader>h", ":set hls!<CR>", opts)
vim.keymap.set("n", "<leader>;", "<C-^>", opts)
-- Close buffer but keep the window: no-name buffer quits, file switches to previous file (or empty buffer)
vim.keymap.set("n", "<C-x>", function()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)

	if vim.bo[buf].filetype == "fyler_finder" then
		require("fyler").close()
		return
	end

	if name == "" and vim.bo[buf].buftype == "" then
		vim.cmd("confirm qall")
		return
	end

	if vim.bo[buf].modified then
		local choice = vim.fn.confirm("Save changes to " .. vim.fn.fnamemodify(name, ":~:.") .. "?", "&Yes\n&No\n&Cancel")
		if choice == 1 then
			vim.cmd("write")
		elseif choice ~= 2 then
			return
		end
	end

	-- Pick replacement: alternate buffer, else most recently used listed file, else a new empty buffer
	local function usable(b)
		return b > 0 and b ~= buf and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].buftype == ""
	end
	local replacement = vim.fn.bufnr("#")
	if not usable(replacement) then
		local infos = vim.fn.getbufinfo({ buflisted = 1 })
		table.sort(infos, function(a, b)
			return a.lastused > b.lastused
		end)
		replacement = nil
		for _, info in ipairs(infos) do
			if usable(info.bufnr) then
				replacement = info.bufnr
				break
			end
		end
	end
	replacement = replacement or vim.api.nvim_create_buf(true, false)

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_set_buf(win, replacement)
	end
	vim.api.nvim_buf_delete(buf, { force = true })
end, opts)

-- =============================================================================
--                                   COMMANDS
-- =============================================================================
-- Read .arb files as json
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.arb",
	command = "set filetype=json",
})

-- Reload and attach LSP client
vim.api.nvim_create_user_command("Reload", function()
	vim.cmd("e!")
	vim.lsp.buf_attach_client(0, vim.lsp.get_clients()[1].id)
end, {})

-- Properly detach LSP clients when closing a buffer
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		local bufnr = args.buf
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		for _, client in ipairs(clients) do
			vim.lsp.buf_detach_client(bufnr, client.id)
		end
	end,
	group = vim.api.nvim_create_augroup("LSPDetachBeforeDelete", {}),
})

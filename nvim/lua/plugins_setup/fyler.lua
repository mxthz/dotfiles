vim.keymap.set("n", "-", function()
	-- Check if fyler buffer exists and is visible
	local fyler_win = nil

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("fyler://") then
			fyler_win = win
			break
		end
	end

	if fyler_win then
		-- Fyler is open, close it
		vim.api.nvim_win_close(fyler_win, false)
	else
		-- Fyler not open, open it as left sidebar
		require("fyler").open({ kind = "split_left" })
	end
end, { desc = "Toggle fyler tree open/close" })

require("fyler").setup({
	default_explorer = true,
	close_on_select = false,
	icon_provider = "nvim_web_devicons",
	track_current_buffer = true,
	win = {
		border = "single",
		kind = "split_left", -- Persistent sidebar on the left
		buf_opts = {
			buflisted = false, -- Don't list fyler buffer in buffer list
			bufhidden = "hide", -- Hide instead of wipe to prevent issues
			buftype = "", -- Allow normal file operations
			swapfile = false, -- No swap file
			modifiable = true, -- Allow modification when needed
		},
	},
	mappings = {
		["q"] = "CloseView",
		["<CR>"] = "Select", -- Opens file in main buffer, keeps tree open
		["<C-t>"] = "SelectTab",
		["|"] = "SelectVSplit",
		["-"] = false, -- Disable fyler's built-in - mapping to prevent conflicts
		["^"] = "GotoParent",
		["="] = "GotoCwd",
		["."] = "GotoNode",
		["#"] = "CollapseAll",
		["<BS>"] = "CollapseNode",
	},
})

-- Strong protection for fyler buffers against replacement
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local buf_name = vim.api.nvim_buf_get_name(0)
		if buf_name:match("fyler://") then
			-- Set buffer options to protect fyler buffer
			vim.bo.buftype = ""
			vim.bo.modifiable = true
			vim.bo.swapfile = false
			vim.bo.buflisted = false
		end
	end,
})

-- Prevent FzfLua and other plugins from targeting fyler windows
vim.api.nvim_create_autocmd("WinEnter", {
	pattern = "*",
	callback = function()
		local buf_name = vim.api.nvim_buf_get_name(0)
		if buf_name:match("fyler://") then
			-- If something tries to open in fyler window, redirect to main buffer
			local main_win = nil
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local win_buf_name = vim.api.nvim_buf_get_name(buf)
				if not win_buf_name:match("fyler://") then
					main_win = win
					break
				end
			end

			-- If there's no main window, create one
			if not main_win then
				-- Check if we're in a valid state to create windows (not during closing operations)
				-- Use pcall to handle the case where window operations might conflict
				local success = pcall(function()
					vim.cmd("wincmd l")
					if vim.api.nvim_buf_get_name(0):match("fyler://") then
						-- Still in fyler, force split to create main buffer
						vim.cmd("vsplit")
						vim.cmd("enew")
					end
				end)

				-- If the operation failed due to window closing conflict, just return silently
				if not success then
					return
				end
			end
		end
	end,
})

-- Override FzfLua to never target fyler windows
local original_fzf_lua = require("fzf-lua")
local original_files = original_fzf_lua.files

require("fzf-lua").files = function(opts)
	opts = opts or {}
	-- Ensure FzfLua opens in main buffer, not fyler
	local current_buf = vim.api.nvim_buf_get_name(0)
	if current_buf:match("fyler://") then
		vim.cmd("wincmd l") -- Move to main buffer before opening FzfLua
	end
	return original_files(opts)
end

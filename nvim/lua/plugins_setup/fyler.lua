vim.keymap.set("n", "-", function()
	local fyler = require("fyler")

	-- Remember current window before toggling
	local cur_win = vim.api.nvim_get_current_win()
	local cur_buf = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(cur_win))
	local is_in_fyler = cur_buf:match("fyler://")

	-- Check if fyler is currently visible
	local fyler_visible = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
		if buf_name:match("fyler://") then
			fyler_visible = true
			break
		end
	end

	fyler.toggle()

	-- If we just opened fyler (it wasn't visible), schedule focus back to file buffer
	if not fyler_visible and not is_in_fyler then
		vim.schedule(function()
			if vim.api.nvim_win_is_valid(cur_win) then
				vim.api.nvim_set_current_win(cur_win)
			end
		end)
	end
end, { desc = "Toggle fyler tree open/close" })

require("fyler").setup({
	use_as_default_explorer = true,
	follow_current_file = true,
	kind = "split_left", -- Persistent sidebar on the left
	integrations = {
		icon = "nvim_web_devicons",
	},
	buf_opts = {
		buflisted = false, -- Don't list fyler buffer in buffer list
		bufhidden = "hide", -- Hide instead of wipe to prevent issues
		buftype = "", -- Allow normal file operations
		swapfile = false, -- No swap file
		modifiable = true, -- Allow modification when needed
	},
	kind_presets = {
		split_left = {
			border = "single",
			width = "25%",
		},
	},
	mappings = {
		n = {
			["q"] = { action = "close", desc = "Close finder" },
			["<CR>"] = { action = "select", args = { pick = true }, desc = "Open with window picker" }, -- Opens file in main buffer, keeps tree open
			["<C-t>"] = { action = "select", args = { tabedit = true }, desc = "Open in new tab" },
			["|"] = { action = "select", args = { vsplit = true }, desc = "Open in vertical split" },
			["-"] = { disabled = true }, -- Disable fyler's built-in - mapping to prevent conflicts
			["^"] = { action = "visit", args = { parent = true }, desc = "Go to parent directory" },
			["="] = { action = "visit", desc = "Go to root directory" },
			["."] = { action = "visit", args = { cursor = true }, desc = "Enter directory under cursor" },
			["<BS>"] = { action = "shrink", args = { parent = true }, desc = "Collapse parent directory" },
		},
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

-- Quit NeoVim when fyler is the last remaining window
vim.api.nvim_create_autocmd("WinClosed", {
	callback = function()
		vim.schedule(function()
			local wins = vim.api.nvim_list_wins()
			if #wins == 1 then
				local buf = vim.api.nvim_win_get_buf(wins[1])
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("fyler://") then
					vim.cmd("quit")
				end
			end
		end)
	end,
})

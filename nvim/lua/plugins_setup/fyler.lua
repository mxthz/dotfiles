vim.keymap.set("n", "-", function()
	local fyler = require("fyler")
	local buf_name = vim.api.nvim_buf_get_name(0)

	-- From inside the tree: close it
	if vim.bo.filetype == "fyler_finder" then
		fyler.close()
		return
	end

	local inst = require("fyler.finder").instance_get_or_nil()

	-- No-name buffer: toggle the tree without focusing it
	if buf_name == "" then
		if inst then
			fyler.close()
			return
		end
		local cur_win = vim.api.nvim_get_current_win()
		fyler.open()
		vim.schedule(function()
			if vim.api.nvim_win_is_valid(cur_win) then
				vim.api.nvim_set_current_win(cur_win)
			end
		end)
		return
	end

	-- Tree closed: open it focused (built-in follow puts cursor on the current file)
	if not inst then
		fyler.open()
		return
	end

	-- Tree already open: jump into it at the current file
	vim.api.nvim_set_current_win(inst.win_id)
	inst:follow({ target_path = buf_name })
end, { desc = "Reveal current file in tree / close tree" })

require("fyler").setup({
	use_as_default_explorer = true,
	follow_current_file = true,
	kind = "split_left", -- Persistent sidebar on the left
	integrations = {
		icon = "nvim_web_devicons",
	},
	extensions = {
		git = {
			enabled = true,
			inline = false, -- Git status colors + right-aligned icons
			-- VSCode-style letters, keyed by `git status --porcelain` XY codes
			icons = {
				[" M"] = { icon = "M", hl = "FylerGitModified" },
				["M "] = { icon = "M", hl = "FylerGitModified" },
				["MM"] = { icon = "M", hl = "FylerGitModified" },
				["A "] = { icon = "A", hl = "FylerGitAdded" },
				["AM"] = { icon = "A", hl = "FylerGitAdded" },
				[" A"] = { icon = "A", hl = "FylerGitAdded" },
				["??"] = { icon = "U", hl = "FylerGitUntracked" },
				[" D"] = { icon = "D", hl = "FylerGitDeleted" },
				["D "] = { icon = "D", hl = "FylerGitDeleted" },
				["R "] = { icon = "R", hl = "FylerGitRenamed" },
				["RM"] = { icon = "R", hl = "FylerGitRenamed" },
				["UU"] = { icon = "!", hl = "FylerGitConflict" },
				["AA"] = { icon = "!", hl = "FylerGitConflict" },
				["DD"] = { icon = "!", hl = "FylerGitConflict" },
				["AU"] = { icon = "!", hl = "FylerGitConflict" },
				["UA"] = { icon = "!", hl = "FylerGitConflict" },
				["DU"] = { icon = "!", hl = "FylerGitConflict" },
				["UD"] = { icon = "!", hl = "FylerGitConflict" },
				["!!"] = { icon = "", hl = "FylerGitIgnored" }, -- VSCode only dims ignored files, no letter
			},
		},
		watcher = { enabled = true }, -- Auto-refresh on filesystem/.git changes (e.g. git add in a terminal)
	},
	hooks = {
		-- VSCode Dark+ gitDecoration colors (runs before the git extension's defaults, so these win)
		on_highlight = function(highlights, palette)
			highlights.FylerDirectoryName = { fg = palette.fg } -- Folder names same color as files, like VSCode
			highlights.FylerGitModified = { fg = "#E2C08D" }
			highlights.FylerGitAdded = { fg = "#81B88B" }
			highlights.FylerGitUntracked = { fg = "#73C991" }
			highlights.FylerGitDeleted = { fg = "#C74E39" }
			highlights.FylerGitRenamed = { fg = "#73C991" }
			highlights.FylerGitConflict = { fg = "#E4676B" }
			highlights.FylerGitIgnored = { fg = "#8C8C8C" }
		end,
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

-- Quit NeoVim when fyler is the last remaining window
vim.api.nvim_create_autocmd("WinClosed", {
	callback = function()
		vim.schedule(function()
			local wins = vim.api.nvim_list_wins()
			if #wins == 1 then
				local buf = vim.api.nvim_win_get_buf(wins[1])
				if vim.bo[buf].filetype == "fyler_finder" then
					vim.cmd("confirm qall") -- Prompts instead of erroring if hidden buffers have unsaved changes
				end
			end
		end)
	end,
})

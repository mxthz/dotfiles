-- Get comment symbol based on file type
local function get_comment_symbol()
	local filetype = vim.bo.filetype

	if filetype == "javascript" or filetype == "typescript" or filetype == "dart" then
		return "//"
	elseif filetype == "lua" then
		return "--"
	elseif filetype == "vim" then
		return '"'
	elseif filetype == "html" or filetype == "xml" then
		return "<!--"
	else
		return "#" -- Default fallback
	end
end

-- Get comment ending based on file type
local function get_comment_end()
	local filetype = vim.bo.filetype

	if filetype == "html" or filetype == "xml" then
		return " -->"
	else
		return ""
	end
end

-- Insert a smart header with the correct comment syntax for the file type
local function insert_header()
	local comment_start = get_comment_symbol()
	local comment_end = get_comment_end()
	local width = 77 - #comment_end

	local header_line = comment_start .. " " .. string.rep("=", width) .. comment_end
	local title = vim.fn.input("Section title: ")

	-- Calculate padding for centering
	local padding = math.floor((width - #title) / 2)
	local title_line = comment_start .. " " .. string.rep(" ", padding) .. title .. comment_end

	-- Insert the header at the current line
	local current_line = vim.fn.line(".")
	vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { header_line, title_line, header_line })
end

-- Map the function directly to <leader>s
vim.keymap.set("n", "<leader>s", insert_header, { noremap = true })

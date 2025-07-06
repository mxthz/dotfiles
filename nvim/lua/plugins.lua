local packer_bootstrap
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Color scheme
	use({ "dracula/vim", as = "dracula" })

	-- File Explorer
	use({
		"stevearc/oil.nvim",
		config = function()
			require("plugins_setup.oil")
		end,
	})

	-- Icons
	use({ "nvim-tree/nvim-web-devicons" })

	-- Comments
	use({ "preservim/nerdcommenter" })

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("plugins_setup.lsp")
		end,
	})

	-- Linters & Formatters
	use({
		"nvimtools/none-ls.nvim",
		requires = { "nvim-lua/plenary.nvim", "jay-babu/mason-null-ls.nvim" },
		config = function()
			require("plugins_setup.none-ls")
		end,
	})

	-- Tree-sitter
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = { "nvim-treesitter/nvim-treesitter-context" },
		run = ":TSUpdate",
		config = function()
			require("plugins_setup.treesitter")
		end,
	})

	-- FZF Lua
	use({
		"ibhagwan/fzf-lua",
		config = function()
			require("plugins_setup.fzf")
		end,
	})

	-- Completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("plugins_setup.cmp")
		end,
	})

	-- Autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- AI Completion
	use({
		"Exafunction/windsurf.nvim",
		requires = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		config = function() end,
	})

	-- Flutter
	use({
		"nvim-flutter/flutter-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
		config = function()
			require("plugins_setup.flutter-tools")
		end,
	})

	-- Vim Airline
	use({ "vim-airline/vim-airline" })

	-- Smear Cursor
	use({
		"sphamba/smear-cursor.nvim",
		config = function()
			require("smear_cursor").setup()
		end,
	})

	-- Automatically sync packer
	if packer_bootstrap then
		require("packer").sync()
	end
end)

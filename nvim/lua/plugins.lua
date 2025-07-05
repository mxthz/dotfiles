-- Check packer installation
local packer_bootstrap
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

return require("packer").startup(function(use)
	-- Packer can manage itself`
	use("wbthomason/packer.nvim")

	-- Color scheme
	use({ "dracula/vim", as = "dracula" })

	-- LSP
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})
	-- Linters & Formatters
	use({ "nvimtools/none-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "jay-babu/mason-null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "nvimtools/none-ls.nvim" } })

	-- File explorer
	use({ "stevearc/oil.nvim" })

	-- Icons
	use({ "nvim-tree/nvim-web-devicons" })

	-- Tree-sitter
	use({
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-context",
	})

	-- FZF Lua
	use({ "ibhagwan/fzf-lua" })

	-- Completion
	use({
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp", -- LSP completion
		"hrsh7th/cmp-buffer", -- buffer completion
		"hrsh7th/cmp-path", -- path completion
		-- snippet completion
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	})

  -- AI completion
    use {
        "Exafunction/windsurf.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            if vim.bo.filetype == "oil" then
                vim.g.codeium_enabled = false
                return
            end
            require("codeium").setup({})
        end
    }

	-- Vim Airline
	use({ "vim-airline/vim-airline" })

	-- Comments
	use({ "preservim/nerdcommenter" })

	-- Autopairs
	use({ "windwp/nvim-autopairs" })

	-- Flutter
	use({
		"nvim-flutter/flutter-tools.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
	})

	use("sphamba/smear-cursor.nvim")
	require("smear_cursor").setup()

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

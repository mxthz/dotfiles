vim.pack.add({
	-- Color scheme
	{ src = "https://github.com/dracula/vim", name = "dracula" },

	-- Core deps
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	-- Icons
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Comments
	{ src = "https://github.com/preservim/nerdcommenter" },

	-- File Explorer
	{ src = "https://github.com/A7Lavinraj/fyler.nvim", name = "fyler.nvim", checkout = "stable" },

	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },

	-- Linters & Formatters
	{ src = "https://github.com/nvimtools/none-ls.nvim" },
	{ src = "https://github.com/jay-babu/mason-null-ls.nvim" },

	-- Tree-sitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },

	-- TypeScript & React support
	{ src = "https://github.com/windwp/nvim-ts-autotag" },

	-- FZF Lua
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- Completion
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },

	-- Autopairs
	{ src = "https://github.com/windwp/nvim-autopairs" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- Flutter
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/stevearc/dressing.nvim" },
})

-- Plugins config
require("plugins_setup.fyler")
require("plugins_setup.lsp")
require("plugins_setup.none-ls")
require("plugins_setup.treesitter")
require("plugins_setup.fzf")
require("plugins_setup.cmp")
require("plugins_setup.gitsigns")
require("plugins_setup.flutter-tools")
require("nvim-autopairs").setup({})

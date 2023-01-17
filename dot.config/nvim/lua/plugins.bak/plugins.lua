
local plugins = {
	{ "williamboman/mason.nvim" }, -- LSP, DAP installer
	{ "jayp0521/mason-nvim-dap.nvim" }, -- Ensure Instsalled Dap Server
	{ "jayp0521/mason-null-ls.nvim" },

	-- My plugins here
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	{ "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
	{ "numToStr/Comment.nvim" },

	{ "kyazdani42/nvim-tree.lua" },

	{ "moll/vim-bbye" },
	{ "nvim-lualine/lualine.nvim" },

	{ "ahmedkhalf/project.nvim" },
	{ "lewis6991/impatient.nvim" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "lambdalisue/suda.vim" }, -- Save as root
	{ "folke/neodev.nvim" }, -- Descriptions and ussage for neovim
	{ "folke/neoconf.nvim" },
	{ "stevearc/aerial.nvim" },
	{ "ellisonleao/glow.nvim" }, -- Terminal Markdown preview

	-- cmp plugins
	{ "hrsh7th/nvim-cmp" }, -- The completion plugin
	{ "hrsh7th/cmp-buffer" }, -- buffer completions
	{ "hrsh7th/cmp-path" }, -- path completions
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "LhKipp/nvim-nu" }, -- Completion for Nushell configuration
	{ "onsails/lspkind.nvim" },

	-- snippets
	{ "L3MON4D3/LuaSnip" }, --snippet engine
	{ "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

	-- LSP
	{ "williamboman/mason-lspconfig.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
	{ "j-hui/fidget.nvim" },
	{ "Hoffs/omnisharp-extended-lsp.nvim" },
	{ "folke/lsp-colors.nvim" },
	{ "kevinhwang91/nvim-bqf" },
	{ "ray-x/lsp_signature.nvim" },
	{ "nanotee/sqls.nvim" },
  {"stevearc/dressing.nvim"},	

  -- Telescope
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "ThePrimeagen/refactoring.nvim" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/Telescope-frecency.nvim", dependencies = { "tami5/sqlite.lua" } },
	{ "nvim-telescope/telescope-smart-history.nvim" },
	{ "s1n7ax/nvim-window-picker" },
	{ "ThePrimeagen/harpoon" },

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter" },
	{ "JoosepAlviste/nvim-ts-context-commentstring" },

	-- Git
	{ "lewis6991/gitsigns.nvim" },

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui" },
	{ "theHamsta/nvim-dap-virtual-text" },
}
-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugin
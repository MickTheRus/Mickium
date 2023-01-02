local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  LAZY_BOOTSRAP = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local lazy = require("lazy")

local opts = {
colorscheme = {"MickTheme"}
  }

-- Install your plugins here
local plugins = {
-- Package Managers
	{ "wbthomason/packer.nvim" }, -- Have packer manage itself
	{ "williamboman/mason.nvim" }, -- LSP, DAP installer
  {"jayp0521/mason-nvim-dap.nvim"}, -- Ensure Instsalled Dap Server
  {"jayp0521/mason-null-ls.nvim"},
  
	-- My plugins here
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	{ "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
	{ "numToStr/Comment.nvim" },
	{ "kyazdani42/nvim-web-devicons" },
	{ "kyazdani42/nvim-tree.lua" },
	{ "akinsho/bufferline.nvim" },
	{ "moll/vim-bbye" },
	{ "nvim-lualine/lualine.nvim" },
	{ "akinsho/toggleterm.nvim" },
	{ "ahmedkhalf/project.nvim" },
	{ "lewis6991/impatient.nvim" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "goolord/alpha-nvim" },
	{ "linty-org/key-menu.nvim" }, -- Keymap manager
	{ "andweeb/presence.nvim" }, -- Discord RP
	{ "lambdalisue/suda.vim" }, -- Save as root
	{ "folke/neodev.nvim" }, -- Descriptions and ussage for neovim
	{ "folke/neoconf.nvim" },
	{ "stevearc/aerial.nvim" },
	{ "ellisonleao/glow.nvim" }, -- Terminal Markdown preview
  -- #TODO: Rewrite in Lua 
  {"kovetskiy/sxhkd-vim"}, -- Sxhkd Highlighting

  {"folke/lsp-colors.nvim"},


	-- cmp plugins
	{ "hrsh7th/nvim-cmp" }, -- The completion plugin
	{ "hrsh7th/cmp-buffer" }, -- buffer completions
	{ "hrsh7th/cmp-path" }, -- path completions
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "LhKipp/nvim-nu" }, -- Completion for Nushell configuration

  -- Coq nvim
  {"ms-jpq/coq_nvim"}, -- Completion Engine 
  {"ms-jpq/coq.artifacts"},
  {"ms-jpq/coq.thirdparty"},

	-- snippets
	{ "L3MON4D3/LuaSnip" }, --snippet engine
	{ "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

	-- LSP
	{ "neovim/nvim-lspconfig" }, -- enable LSP
	{ "williamboman/mason-lspconfig.nvim" },

	{ "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
	{ "RRethy/vim-illuminate" },
	{ "j-hui/fidget.nvim" },
	{ "Hoffs/omnisharp-extended-lsp.nvim" },

	-- Telescope
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "ThePrimeagen/refactoring.nvim" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	-- Performance Increase
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
	-- Put this at the end after all plugins
if LAZY_BOOTSTRAP then
  vim.cmd[[packadd Lazy]]
end
lazy.setup(plugins,opts)

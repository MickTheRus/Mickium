local icons = require("icons")

require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- one of "all", or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "haskell", "elixir", "phpdoc", "help" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "sql" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
		disable = { "yaml" },
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})

require("treesitter-context").setup()

require("nvim_context_vt").setup({
	prefix = icons.ArrowRight,
})
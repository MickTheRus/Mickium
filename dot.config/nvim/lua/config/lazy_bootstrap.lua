local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
	defaults = { lazy = true },
	-- install = { colorscheme = { "Catppucchin" } },
	ui = {
		border = 'rounded',
	},
	checker = { enabled = true, notify = false },
	change_detection = { enabled = true, notify = false, },
	performance = {
		cache = {
			enabled = true,
			path = vim.fn.stdpath("cache") .. "/lazy/cache",
			--   VimEnter: not useful to cache anything else beyond startup
			--   BufReadPre: this will be triggered early when opening a file from the command line directly
			disable_events = { "VimEnter", "BufReadPre" },
			-- ttl = 3600  24  5, -- keep unused modules for up to 5 days
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"zip",
				"zipPlugin",
				"fzf",
				"tar",
				"tarPlugin",
				"getscript",
				"getscriptPlugin",
				"vimball",
				"vimballPlugin",
				"2html_plugin",
				"matchit",
				"matchparen",
				"logiPat",
				"rrhelper",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"tohtml",
				"tutor",
			},
		},
	},
	-- debug = true,
})


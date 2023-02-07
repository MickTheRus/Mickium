vim.g.mapleader        = " "
require("config/lazy_bootstrap")

require("config.settings")
require("config.autocmds")
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.keymaps")
		require("config.commands")
	end,
})

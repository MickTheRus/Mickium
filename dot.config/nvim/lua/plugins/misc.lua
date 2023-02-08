-- All plugins are lazy-loaded by default
return {
	{ "nvim-lua/plenary.nvim" },
	{ "max397574/better-escape.nvim", config = true, event = "BufReadPre" },
	{
"linty-org/key-menu.nvim",
		event = "BufReadPost",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 10
		    require("key-menu").set("n","<Space>")
        end,
	},
	{ "kylechui/nvim-surround", config = true, event = "BufReadPost" },
}

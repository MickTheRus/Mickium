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
			local km = require("key-menu").set
			km("", "<Space>")
			km("n", "<leader>l", { desc = "Lsp" })
			km("n", "<leader>b", { desc = "Buffers" })
		end,
	},
	{ "kylechui/nvim-surround", config = true, event = "BufReadPost" },
	{
		"famiu/bufdelete.nvim",
		keys = {
			{ "<leader>bd", "<cmd>Bdelete!<cr>", desc = "Close Buffers" },
		},
	},
}

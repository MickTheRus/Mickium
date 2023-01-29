local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {"catppuccin/nvim",
	as = "catppuccin"},

	config = function()
		require("lualine").setup({
			theme = "catppuccin",
		})
	end
}



return M

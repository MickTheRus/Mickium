local M = {
	"mawkler/modicator.nvim",
	event = "ColorScheme",
}

function M.config()
	require("modicator").setup({
		show_warnings = true,
		highlights = {
			defaults = {
				bold = true,
				italic = false,
			},
		},
	})

	vim.api.nvim_create_autocmd({ "Colorscheme" }, {
		callback = function()
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#388bfd", bg = "NONE" })
		end,
	})
end

return M


local M = {
	"folke/which-key.nvim",
	keys = { '<space>' }
}

function M.config()
	require('which-key').setup({
		window = {
			border   = 'rounded',
			position = 'bottom',
			margin   = { 1, 0, 1, 0 },
			padding  = { 2, 2, 2, 2 },
			winblend = 0
		},
		icons = {
			breadcrumb = '»',
			separator  = '➡  ',
			group      = ' ',
		},
		plugins = {
			marks     = false,
			registers = false,
			spelling = {
				enabled     = false,
				suggestions = 20,
			},
		},
		presets = {
			operators    = false,
			motions      = false,
			text_objects = false,
			windows      = true,
			nav          = true,
			z            = true,
			g            = true,
		},
		key_labels = {
			['<space>'] = 'SPC',
			['<cr>']    = 'RET',
			['<tab>']   = 'TAB',
		},
	})
end

return M

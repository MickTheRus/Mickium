local M = {
	'goolord/alpha-nvim',
	disable  = false,
	event    = 'VimEnter',
	dependencies = {
		{
			'nvim-tree/nvim-web-devicons',
			config = function ()
				require('nvim-web-devicons').setup()
			end
		},
	},
}

function M.config()
	-- require'alpha'.setup(require'alpha.themes.startify'.config)
	local alpha    = require('alpha')
	local startify = require('alpha.themes.startify')
	startify.section.header.val = {
		[[                                   __                ]],
		[[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
		[[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
		[[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
		[[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
		[[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
	}
	startify.section.top_buttons.val = {
		startify.button( 'e', '  New file' , '<cmd>ene <BAR> startinsert <CR>'),
	}
	startify.nvim_web_devicons.enabled = true
	startify.section.bottom_buttons.val = {
		startify.button( 'q', '  Quit this Screen' , '<cmd>bdelete<CR>'),
		startify.button( 'X', '  Quit NV!M' , '<cmd>qall<CR>'),
	}
	startify.section.footer = {
		{ type = 'text', val = 'footer' },
	}
	startify.mru_opts.ignore = function(path, _)
		return
		(string.find(path, 'COMMIT_EDITMSG'))
	end

	--[[ startify.config.layout = {
        { type = "padding", val = 1 },
        startify.section.header,
        { type = "padding", val = 2 },
        startify.section.top_buttons,
        startify.section.mru,
        startify.section.mru_cwd,
        { type = "padding", val = 1 },
        startify.section.bottom_buttons,
        startify.section.footer,
	} ]]

	alpha.setup(startify.config)
end
return M

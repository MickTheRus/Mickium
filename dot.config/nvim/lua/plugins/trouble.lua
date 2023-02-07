local M = {
	'folke/trouble.nvim',
	enabled = true,
	-- event = 'LspAttach',
	cmd = { 'Trouble' }
}

function M.config()
	require('trouble').setup({
		auto_open    = false,
		auto_close   = true,
		padding      = false,
		height       = 5,
		signs        = { error = '', warning = '', hint = '', information = '', other = '', },
		track_cursor = true,

		action_keys = {
			close          = 'q',
			cancel         = '<esc>',
			refresh        = 'r',
			jump           = { '<cr>', '<tab>' },
			jump_close     = { 'o' },
			toggle_mode    = 'm',
			toggle_preview = 'P',
			hover          = 'K',
			preview        = 'p',
			close_folds    = { 'zM', 'zm' },
			open_folds     = { 'zR', 'zr' },
			toggle_fold    = { 'zA', 'za' },
			previous       = 'k',
			next           = 'j'
		},
	})
end

return M

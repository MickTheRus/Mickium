local M = {
	'Yggdroot/LeaderF',
	enabled = true,
	cmd = { 'Leaderf', 'LeaderfRgInteractive' },
	run = '<cmd>LeaderfInstallCExtension<cr>',
}

function M.init()
  	local function map(mode, l, r, opts)
  		opts = opts or {}
  		vim.keymap.set(mode, l, r, opts)
  	end
  	map('n', '<leader>fo', '<cmd>Leaderf file<CR>')
  	map('n', '<leader>fr', '<cmd>Leaderf mru<CR>')
  	map('n', '<leader>ft', '<cmd>Leaderf bufTag<CR>')
  	map('n', '<leader>/',  '<cmd>LeaderfRgInteractive<CR>')
end

function M.config()
	vim.g.Lf_WindowPosition        = 'popup'
	vim.g.Lf_WorkingDirectoryMode  = 'Ac'
	vim.g.Lf_ShowDevIcons          = 1
	vim.g.Lf_ShowHidden 					 = 1
	vim.g.Lf_DefaultMode           = 'NameOnly'
	vim.g.Lf_WindowHeight          = 0.3
	vim.g.Lf_PopupWidth            = 0.8
	vim.g.Lf_PopupPosition         = { 0, 0 }
	vim.g.Lf_CursorBlink           = 0
	vim.g.Lf_UseVersionControlTool = 0
	vim.g.Lf_PopupShowStatusline   = 0
	vim.g.Lf_PopupShowBorder       = 1
	vim.g.Lf_PopupBorders          = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
	vim.g.Lf_ShowRelativePath      = 0
	vim.g.Lf_StlSeparator          = { left = '', right = '', font = '' }
end

return M

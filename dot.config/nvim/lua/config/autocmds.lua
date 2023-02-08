local group = vim.api.nvim_create_augroup('AutoCommands', { clear = true })
vim.api.nvim_create_autocmd('Filetype', { pattern = 'sh', group = group,
command = 'setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4' })
vim.api.nvim_create_autocmd('FocusLost,InsertLeave,CursorHold', { group = group,
command = 'silent! update' })
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = '[^l]*', group = group,
callback = function() TroubleQuickFixPost('quickfix') end })
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'l*', group = group,
callback = function() TroubleQuickFixPost('loclist') end })
vim.api.nvim_create_autocmd('TextYankPost', { group = group,
callback = function() vim.highlight.on_yank({ higroup='YankyYanked', timeout=100 }) end })

-- set the colorcolumn to 72 for gitcommit filetype
local colorcolGrp = vim.api.nvim_create_augroup('colorcolGrp', { clear = true })
vim.api.nvim_create_autocmd('Filetype', { pattern = 'gitcommit', group = colorcolGrp, command = 'setlocal colorcolumn=72' })

-- Change the current line number bg color in insert and non-insert mode
local cursorGrp = vim.api.nvim_create_augroup('cursorGrp', { clear = true })
vim.api.nvim_create_autocmd( 'InsertLeave' , { group = cursorGrp, command = 'hi CursorLineNr guifg=#f0f0f0 guibg=#b16286' })
vim.api.nvim_create_autocmd( 'InsertEnter' , { group = cursorGrp, command = 'hi CursorLineNr guifg=#f0f0f0 guibg=#2AA198' })

-- Enable relative number only in non-insert mode
vim.api.nvim_create_autocmd(
{ 'InsertLeave', 'WinEnter' },
{ pattern = '*', command = 'set relativenumber', group = cursorGrp })

vim.api.nvim_create_autocmd(
{ 'InsertEnter', 'WinLeave' },
{ pattern = '*', command = 'set norelativenumber', group = cursorGrp })

-- Notification for packer compilation/sync completion
local packerGrp = vim.api.nvim_create_augroup('packerGrp', { clear = true })
-- vim.api.nvim_create_autocmd('User' , { pattern = 'PackerComplete', group = packerGrp,
-- command = 'lua vim.notify(\'Packer Sync Done!\', info)' })
vim.api.nvim_create_autocmd('User' , { pattern = 'PackerCompileDone', group = packerGrp,
callback = function(_)
	vim.notify( (' Compiled at %s'):format(os.date()), vim.log.levels.INFO,
	{ title = 'Packer' })
end
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- sqls
vim.api.nvim_create_autocmd('User', {
	pattern = 'SqlsConnectionChoice',
	callback = function(event)
		vim.notify(event.data.choice)
	end,
})

-- Utility functions
_G.P = vim.pretty_print

function _G.TroubleQuickFixPost(mode)
	require('trouble.providers').get(vim.api.nvim_get_current_win(),
	vim.api.nvim_get_current_buf(), function(items)
		if #items > 0 then require('trouble').open({ mode = mode }) end
	end, { mode = mode })
end


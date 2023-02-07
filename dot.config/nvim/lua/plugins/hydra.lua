local M = {
	'anuvyklack/hydra.nvim',
	-- event = 'VeryLazy',
	keys = { '<space>g' },
	dependencies = {
		'anuvyklack/keymap-layer.nvim',
		'NvChad/nvim-colorizer.lua',
	},
}

function M.config()
	local Hydra = require('hydra')
local gitsigns = require('gitsigns')

local hint = [[
 _j_: next hunk       _k_: prev hunk       ^ ^
 _d_: show deleted    _D_: Word diff       ^ ^
 _u_: undo stage hunk _r_: reset hunk      ^ ^
 _b_: blame line      _B_: blame show full ^ ^
 _s_: stage hunk      _S_: stage buffer    ^ ^
 _/_: show base file  _p_: preview hunk    ^ ^
^
^_<Enter>_: Neogit    q_/<Esc>: exit
]]
Hydra({
	name = "Git",
	hint = hint,
	config = {
		color = "pink",
		invoke_on_body = true,
		-- buffer = bufnr,
		hint = {
			offset   = 1,
			position = 'middle-right',
			border   = "rounded"
		},
		on_enter = function()
			vim.cmd('echo')
			vim.cmd([[ColorizerDetachFromBuffer]])
			-- vim.cmd([[CccHighlighterDisable]])
			vim.cmd 'mkview'
			vim.cmd 'silent! %foldopen!'
			gitsigns.toggle_signs(true)
			gitsigns.toggle_linehl(true)
			gitsigns.toggle_word_diff(true)
		end,
		on_exit = function()
			vim.cmd('echo')
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.cmd 'loadview'
			vim.api.nvim_win_set_cursor(0, cursor_pos)
			vim.cmd 'normal zv'
			gitsigns.toggle_signs(true)
			gitsigns.toggle_linehl(false)
			gitsigns.toggle_deleted(false)
			gitsigns.toggle_word_diff(false)
			-- vim.cmd([[CccHighlighterEnable]])
			vim.cmd([[ColorizerAttachToBuffer]])
		end
	},
	mode = { 'n', 'x' },
	body = '<leader>g',
	heads = {
		{ 'j', function()
			if vim.wo.diff then return ']c' end
			gitsigns.next_hunk()
			return '<Ignore>'
		end, { expr = true }},
		{ 'k', function()
			if vim.wo.diff then return '[c' end
			gitsigns.prev_hunk()
			return '<Ignore>'
		end, { expr = true }},
    { 's', gitsigns.stage_hunk,          { silent = true             }},
    { 'u', gitsigns.undo_stage_hunk,     { desc = 'Undo Staged Hunk' }},
    { 'S', gitsigns.stage_buffer,        { desc = 'Stage buffer'     }},
    { 'r', gitsigns.reset_hunk,          { desc = 'Reset Hunk'       }},
    { 'p', gitsigns.preview_hunk,        { desc = 'Preview Hunk'     }},
    { 'i', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk'     }},
    { 'd', gitsigns.toggle_deleted,      { nowait = true             }},
    { 'D', gitsigns.toggle_word_diff,    { nowait = true             }},
    { 'b', gitsigns.blame_line,          { desc = "Blame Line"       }},
		{ 'B', function() gitsigns.blame_line { full = true } end },
		{ '/',       gitsigns.show,     { exit = true }},
		{ '<Enter>', '<cmd>Neogit<CR>', { exit = true }},
		{ '<Esc>',   nil,               { exit = true,     nowait = true }},
		{ 'q',       nil,               { exit = true,     nowait = true }},
	}
})
end
return M

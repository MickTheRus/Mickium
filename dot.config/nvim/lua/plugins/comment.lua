local M = {
	'numToStr/Comment.nvim',
	event = 'VeryLazy',
	keys = { 'gc', 'gcc', 'gb', 'gbc', '<A-;>' },
}

function M.config()
	require('Comment').setup({
		padding = true,
		sticky  = true,
		ignore  = nil,
		toggler = {
			line = 'gcc',
			block = 'gbb',
		},
		opleader = {
			line  = 'gc',
			block = 'gb',
		},

		extra = {
			above = 'gcO',
			below = 'gco',
			eol   = '<A-;>',
		},

		mappings = {
			basic    = true,
			extra    = true,
			extended = false,
		},
		pre_hook = function(ctx)
			local line_start = (ctx.srow or ctx.range.srow) - 1
			local line_end = ctx.erow or ctx.range.erow
			-- require('lsp-inlayhints.core').clear(0, line_start, line_end)
			vim.api.nvim_buf_clear_namespace(0, -1, line_start, line_end)
		end,
		post_hook = nil,
	})
end
return M

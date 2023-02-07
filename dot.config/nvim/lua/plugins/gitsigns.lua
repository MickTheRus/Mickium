-- Copyright (c) 2023 Ratheesh <ratheeshreddy@gmail.com>
-- License: MIT
-- Gitsigns plugin config

local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
}

function M.config()
	require('gitsigns').setup({
		on_attach = function(bufnr)
			-- local gs = package.loaded.gitsigns
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end
			map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		end,
		signs = {
			add          = { text = "│" },
			change       = { text = "│" },
			delete       = { text = "─" },
			topdelete    = { text = "▾" },
			changedelete = { text = "│" },
			untracked    = { text = "│" },
		},
		diff_opts = {
			internal = true,
		},
		preview_config = {
			border   = 'rounded',
			style    = 'minimal',
			relative = 'cursor',
			row      = 0,
			col      = 1
		}
	})
end

return M

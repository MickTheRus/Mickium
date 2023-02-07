local M = {
  "folke/noice.nvim",
	event = { 'VeryLazy' },
	dependencies = {
		"MunifTanjim/nui.nvim",
		'rcarriga/nvim-notify'
	}
}

M.enabled = true

function M.config()
local focused = true
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      focused = true
    end,
  })
  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
      focused = false
    end,
  })
  require("noice").setup({
    debug = false,
	cmdline = {
		enabled = true,
		view = 'cmdline',
		format = {
			cmdline = { icon = '>_' },
			lua = false,
			filter = false,
			help = false,
		},
	},
    lsp = {
		signature = {
			enabled = false,
		},
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
	messages = {
		enabled = true,
		view = 'mini',
		view_warn = 'mini',
		view_error = 'mini',
		view_history = 'messages',
		view_search  = false
	},
	popupmenu = {
		enabled = true,
		backend = 'cmp'
	},
	views = {
		mini = {
			position = {
				row = '95%',
				col = '98%',
			},
		},
		cmdline_popup = {
			position = {
				row = '30%',
				col = '50%',
			},
			size = {
				width = '40%',
				height = 'auto',
			},
		},
		popupmenu = {
			relative = 'editor',
			position = {
				-- row = 8,
				col = "50%",
			},
			size = {
				width  = '40%',
				height = 10,
			},
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
			},
		},
	},
    routes = {
		{
			filter = {
				cond = function()
					return not focused
				end,
			},
			view = "notify_send",
			opts = { stop = false },
		},
		filter = {
			event = 'msg_show',
			kind = '',
			find = '%d+B written',
		},
		opts = { skip = true },
		{
			filter = {
				event = 'msg_show',
				kind = '',
				find = 'before #%d+',
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = 'msg_show',
				kind = '',
				find = 'written',
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = 'msg_show',
				kind = '',
				find = 'more lines?',
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = 'msg_show',
				kind = '',
				find = 'lines? yank',
			},
			opts = { skip = true },

		},
	},
	notify = {
		enabled = true,
	},
	health = {
		checker = true,
	},
	smart_move = {
		enabled = true,
		excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
	},
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      cmdline_output_to_split = false,
    },
    commands = {
      all = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    },
    format = {
      level = {
        icons = false,
      },
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
      vim.schedule(function()
        require("noice.text.markdown").keys(event.buf)
      end)
    end,
  })
end

return M

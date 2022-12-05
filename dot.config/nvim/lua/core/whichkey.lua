local wk = require("which-key")

local i = require("icons")

local setup = {
	plugins = {
		spelling = {
			enabled = true,
		},
	},
	icons = {
		breadcrumb = " ",
		separator = " ",
		group = "",
	},
	window = {
		border = "rounded",
		position = "bottom",
		winblend = 25,
	},
	layout = {
		align = "center",
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = nil,
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["<leader>"] = {
		e = { "<cmd>NvimTreeToggle<cr>", i.NvimTree .. "Explorer" },
		h = { "<cmd>nohlsearch<CR>", i.NoHighlight .. "Clear highlight" },

		b = {
			name = i.Buffer .. "Buffer",
			s = { "<cmd>w!<CR>", i.Save .. "Save" },
			d = { "<cmd>Bdelete<CR>", i.Close .. "Close" },
		},

		j = {
			name = i.Window .. "Window",
			d = { "<cmd>q<CR>", i.Close .. "Close" },
			a = { "<cmd>qa<CR>", i.CloseAll .. "Close all" },
		},

		p = {
			name = " Packer",
			S = { "<cmd>PackerStatus<cr>", "Status" },
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
			r = { "<cmd>so %<cr>", "Source current file" },
		},

		l = {
			name = i.Field .. "LSP",
			I = { "<cmd>Mason<cr>", "Installer Info" },
			a = { vim.lsp.buf.code_action, "Code Action" },
			f = { vim.lsp.buf.format, "Format" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			j = { vim.diagnostic.goto_next, "Next Diagnostic" },
			k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
			l = { vim.lsp.codelens.run, "CodeLens Action" },
			q = { vim.diagnostic.set_loclist, "Quickfix" },
			r = { vim.lsp.buf.rename, "Rename" },
			d = {
				name = "Debug",
				b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
				c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
				i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
				o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
				O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
				r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
				l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
				u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
				x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
			},
		},
	},

	K = { vim.lsp.buf.hover, i.Comment .. "Hover" },

	g = {
		name = i.Goto .. "Go to",
		a = { vim.lsp.buf.range_code_action, i.Event .. "Code actions" },
		l = { vim.diagnostic.open_float, i.Warning .. "Diagnostics" },
	},

	["<C-h>"] = { "<cmd>wincmd h<cr>", i.ChevronLeft .. "Left" },
	["<C-j>"] = { "<cmd>wincmd j<cr>", i.ChevronDown .. "Down" },
	["<C-k>"] = { "<cmd>wincmd k<cr>", i.ChevronUp .. "Up" },
	["<C-l>"] = { "<cmd>wincmd l<cr>", i.ChevronRight .. "Right" },
}

local vmappings = {
	["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
}
wk.setup(setup)
wk.register(mappings, opts)
wk.register(vmappings, vopts)

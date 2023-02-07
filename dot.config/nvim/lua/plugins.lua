return {
	{
		"folke/neodev.nvim",
		enabled = false,
		event = 'VeryLazy',
		config = function ()
			require('neodev').setup()
		end
	},
	{ 'mattn/emmet-vim', ft = { 'html', 'css', 'scss', 'xml' } },
	{ "williamboman/mason-lspconfig.nvim", event = 'LspAttach' },
	{ "tpope/vim-repeat", keys = "." },
	{
		"luukvbaal/statuscol.nvim",
		enabled = false,
		event = 'VeryLazy',
		config = function()
			local builtin = require('statuscol.builtin')
			local cfg = {
				separator   = true,
				thousands   = false,
				relculright = false,
				lnumfunc    = nil,
				reeval      = false,
				setopt      = true,
				order       = "FSNs",
				-- Click actions
				Lnum                   = builtin.lnum_click,
				FoldPlus               = builtin.foldplus_click,
				FoldMinus              = builtin.foldminus_click,
				FoldEmpty              = builtin.foldempty_click,
				DapBreakpointRejected  = builtin.toggle_breakpoint,
				DapBreakpoint          = builtin.toggle_breakpoint,
				DapBreakpointCondition = builtin.toggle_breakpoint,
				DiagnosticSignError    = builtin.diagnostic_click,
				DiagnosticSignHint     = builtin.diagnostic_click,
				DiagnosticSignInfo     = builtin.diagnostic_click,
				DiagnosticSignWarn     = builtin.diagnostic_click,
				GitSignsTopdelete      = builtin.gitsigns_click,
				GitSignsUntracked      = builtin.gitsigns_click,
				GitSignsAdd            = builtin.gitsigns_click,
				GitSignsChangedelete   = builtin.gitsigns_click,
				GitSignsDelete         = builtin.gitsigns_click,
			}
			require('statuscol').setup(cfg)
			-- vim.opt.statuscolumn   = '%=%{v:relnum?v:relnum:v:wrap ? "" : v:lnum} %#SignColumn#%s'
			-- vim.opt.statuscolumn   = '%=%{v:relnum?v:relnum:v:wrap ? "" : v:lnum}▕%#SignColumn# %s%#FoldColumn#%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "▼" : "▶") : "│") : " " }'
		end
	},
	{
		'winston0410/range-highlight.nvim',
		event = { 'CmdlineEnter' },
		dependencies = { "winston0410/cmd-parser.nvim"  }
	},
	{
		'hood/popui.nvim',
		disable = false,
		config = function()
			vim.ui.select = require('popui.ui-overrider')
			vim.ui.input = require('popui.input-overrider')
		end
	},
	-- "rlch/github-notifications.nvim",
	{ 'psliwka/vim-smoothie', keys = { '<c-u>', '<c-d>' }},
	{ "folke/neoconf.nvim", enabled = false, cmd = "Neoconf" },
	{
		"lukas-reineke/virt-column.nvim",
		enabled = true,
		event   = 'VeryLazy',
		config = function ()
			require("virt-column").setup({char = '▕', virtcolumn = '+1'})
		end
	},
	{
		'xiyaowong/virtcolumn.nvim',
		enabled = false,
		event = 'BufReadPost',
		config = function ()
			vim.g.virtcolumn_char = '▕'
			vim.g.virtcolumn_priority = 10
		end
	},
	{
		'NvChad/nvim-colorizer.lua',
		event = 'VeryLazy',
		config = function ()
			require('colorizer').setup()
			-- vim.cmd([[ColorizerAttachToBuffer]])
		end
	},
	-- { "EdenEast/nightfox.nvim", event = "VeryLazy" },
	{
		"mbbill/undotree",
		cmd = { "UndotreeShow", "UndotreeToggle", "UndotreeHide", "UndotreeFocus" },
	},
	{
		'echasnovski/mini.indentscope',
		event = 'LspAttach',
		config = function()
			require('mini.indentscope').setup({
				symbol = '╎',
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = function()
			require("inc_rename").setup()
		end,
	},
	{
		"ojroques/vim-oscyank",
		cmd = { "OSCYank", "OSCYankReg" },
	},
	-- { "NvChad/nvim-colorizer.lua", ft = { "css" } },
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"ThePrimeagen/refactoring.nvim",
		init = function()
			-- prompt for a refactor to apply when the remap is triggered
			vim.keymap.set("v", "<leader>r", function()
				require("refactoring").select_refactor()
			end, { noremap = true, silent = true, expr = false })
		end,
		config = function()
			require("refactoring").setup({})
		end,
	},
	{
		'ckolkey/ts-node-action',
		enabled =  true,
		dependencies = { 'nvim-treesitter' },
		config = function()
			require("ts-node-action").setup({})
			vim.keymap.set({ "n" }, "<bs>", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
		end
	},
	{
		"simrat39/symbols-outline.nvim",
		enabled = false,
		cmd = "SymbolsOutline",
		init = function()
			vim.keymap.set("n", "<leader>cs", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
		end,
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"m-demare/hlargs.nvim",
		event = "VeryLazy",
		enabled = false,
		config = function()
			require("hlargs").setup({
				excluded_argnames = {
					usages = {
						lua = { "self", "use" },
					},
				},
			})
		end,
	},
	{
		"cshuaimin/ssr.nvim",
		enabled = true,
		keys = { '<space>cR' },
		init = function()
			vim.keymap.set({ "n", "x" }, "<leader>cR", function()
				require("ssr").open()
			end, { desc = "Structural Replace" })
		end,
	},
	{
		'kylechui/nvim-surround',
		event = 'VeryLazy',
		keys = { n = { 'ds', 'cs' }, x = { 'S' } },
		config = function ()
			require('nvim-surround').setup({
				highlight = {
					duration = 300,
				}
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = function()
			require("treesitter-context").setup()
		end,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	},
	{
		'lewis6991/hover.nvim',
		enabled = true,
		event = 'LspAttach',
		require = 'nvim-lspconfig',
		config = function()
			require('hover').setup {
				init = function()
					-- Require providers
					require('hover.providers.lsp')
					require('hover.providers.man')
				end,
				preview_opts = {
					border = 'rounded',
				},
				title = true
			}
			vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
		end
	},
	{
		"dstein64/vim-startuptime",
		enabled = false,
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		'asiryk/auto-hlsearch.nvim',
		enabled = false,
		init = function ()
			require("auto-hlsearch").setup({
				remap_keys = { "/", "?", "*", "#", "n", "N" },
			})
		end
	},
	{
		'lewis6991/satellite.nvim',
		enabled = true,
		event = 'VeryLazy',
		config = function ()
			require('satellite').setup()
		end
	},
	{
		'echasnovski/mini.align',
		enabled = true,
		init = function ()
			require('mini.align').setup()
		end
	},
	{
		'junegunn/vim-easy-align',
		enabled = false,
		event   = "VeryLazy",
		config  = function ()
			vim.cmd([[
			xmap ga <Plug>(EasyAlign)
			nmap ga <Plug>(EasyAlign)
			]])
		end
	},
	{
		'dhruvasagar/vim-table-mode',
		cmd = { 'TableModeToggle' , 'TableModeEnable', 'TableModeDisable', 'TableModeRealign' },
		config = function ()
			vim.g.table_mode_corner_corner   = '+'
			vim.g.table_mode_header_fillchar = '='
			vim.b.table_mode_corner          = '+'
		end
	},
	{
		'antoyo/vim-licenses',
		cmd = { 'Gplv2', 'Apache', 'Mit' },
		config = function ()
			vim.g.licenses_copyright_holders_name = 'Ratheesh <ratheeshreddy@gmail.com>'
			vim.g.licenses_authors_name           = 'Ratheesh S'
			vim.g.licenses_default_commands       = { 'Gplv2', 'Apache', 'Mit' }
		end
	},
	{
		'lewis6991/spaceless.nvim',
		event = 'VeryLazy',
		config = function()
			require('spaceless').setup()
		end
	},
	{
		'echasnovski/mini.move',
		enabled = true,
		config = function ()
			require('mini.move').setup()
		end
	}
}
-- End of File

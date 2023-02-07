local M = {
	'windwp/windline.nvim',
	enabled = true,
	event = 'VeryLazy'
}

function M.config()
local windline = require('windline')
local helper   = require('windline.helpers')
local sep      = helper.separators
local Hydra    = require("hydra.statusline")

local b_components = require('windline.components.basic')
local state = _G.WindLine.state

local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

local hl_list = {
	Black    = { 'white'      , 'black'      },
	White    = { 'black'      , 'white'      },
	Inactive = { 'InactiveFg' , 'InactiveBg' },
	Active   = { 'ActiveFg'   , 'ActiveBg'   },

	-- Left Space
	LeftSpace = { 'ActiveFg', 'ActiveBg' },

	-- Mode
	ModeNormal  = {'ModeNormalFg'  , 'ModeNormalBg'  },
	ModeInsert  = {'ModeInsertFg'  , 'ModeInsertBg'  },
	ModeVisual  = {'ModeVisualFg'  , 'ModeVisualBg'  },
	ModeReplace = {'ModeReplaceFg' , 'ModeReplaceBg' },
	ModeCommand = {'ModeCommandFg' , 'ModeCommandBg' },

	-- File
	File      = { 'FileNameBg',  'ActiveBg',     'italic' },
	FileIcon  = { 'FileNameFg',  'FileNameBg' },
	SearchCnt = { 'SearchCntFg', 'FileNameBg' },

	-- Navic     = { 'NavicBg', 'ActiveBg' },

	-- Git status
	GitDiffAdded   = { 'GitAddedFg',   'ActiveBg' },
	GitDiffRemoved = { 'GitRemovedFg', 'ActiveBg' },
	GitDiffChanged = { 'GitChangedFg', 'ActiveBg' },

-- spell right sep
	PasteRightProjSep = { 'PasteModeBg', 'NormalBg' },
	PasteRightFileSep = { 'PasteModeBg', 'NormalBg' },
}

-- local hide_in_width = function() return vim.fn.winwidth(0) > 90 end

local basic = {}

basic.divider = { b_components.divider, '' }
basic.space   = { ' ', '' }
basic.bg      = { ' ', 'StatusLine' }
basic.file_name_inactive = { b_components.full_file_name, hl_list.Inactive }
basic.line_col_inactive  = { b_components.line_col, hl_list.Inactive }
basic.progress_inactive  = { b_components.progress, hl_list.Inactive }

basic.vi_mode = {
	name = 'vi_mode',
	hl_colors = {
		Normal        = hl_list.ModeNormal,
		Insert        = hl_list.ModeInsert,
		Visual        = hl_list.ModeVisual,
		Replace       = hl_list.ModeReplace,
		Command       = hl_list.ModeCommand,
		NormalBefore  = { 'ModeNormalBg', 'black' },
		InsertBefore  = { 'ModeInsertBg', 'black' },
		VisualBefore  = { 'ModeVisualBg', 'black' },
		ReplaceBefore = { 'ModeReplaceBg', 'black' },
		CommandBefore = { 'ModeCommandBg', 'black' },
		NormalAfter   = { 'FileNameBg', 'ModeNormalBg' },
		InsertAfter   = { 'FileNameBg', 'ModeInsertBg' },
		VisualAfter   = { 'FileNameBg', 'ModeVisualBg' },
		ReplaceAfter  = { 'FileNameBg', 'ModeReplaceBg' },
		CommandAfter  = { 'FileNameBg', 'ModeCommandBg' },
	},

	text = function()
		if Hydra.is_active() then
			return {
				{ sep.left_rounded, state.mode[2] .. 'Before' },
				{ ' ' ..  Hydra.get_name() .. ' ', state.mode[2] },
			}
		else
			return {
				{ sep.left_rounded, state.mode[2] .. 'Before' },
				{ state.mode[1], state.mode[2] },
				-- { sep.left_rounded, state.mode[2] .. 'After' },
			}
		end
	end,
}

basic.mode_rightsep = {
	hl_colors = {
		default  = {'FileNameFg', 'FileNameBg'},
		sep_left = {'ProjectNameBg', 'FileNameBg'},
		FileNormalAfter     = { 'FileNameBg'    , 'ModeNormalBg'  },
		FileInsertAfter     = { 'FileNameBg'    , 'ModeInsertBg'  },
		FileVisualAfter     = { 'FileNameBg'    , 'ModeVisualBg'  },
		FileReplaceAfter    = { 'FileNameBg'    , 'ModeReplaceBg' },
		FileCommandAfter    = { 'FileNameBg'    , 'ModeCommandBg' },
		PasteNormalAfter    = { 'PasteModeBg'   , 'ModeNormalBg'  },
		PasteInsertAfter    = { 'PasteModeBg'   , 'ModeInsertBg'  },
		PasteVisualAfter    = { 'PasteModeBg'   , 'ModeVisualBg'  },
		PasteReplaceAfter   = { 'PasteModeBg'   , 'ModeReplaceBg' },
		PasteCommandAfter   = { 'PasteModeBg'   , 'ModeCommandBg' },
		ProjectNormalAfter  = { 'ProjectNameBg' , 'ModeNormalBg'  },
		ProjectInsertAfter  = { 'ProjectNameBg' , 'ModeInsertBg'  },
		ProjectVisualAfter  = { 'ProjectNameBg' , 'ModeVisualBg'  },
		ProjectReplaceAfter = { 'ProjectNameBg' , 'ModeReplaceBg' },
		ProjectCommandAfter = { 'ProjectNameBg' , 'ModeCommandBg' },
		NormalAfter         = { 'ModeNormalBg'  , 'NormalBg' 		},
		InsertAfter         = { 'ModeInsertBg'  , 'NormalBg' 		},
		VisualAfter         = { 'ModeVisualBg'  , 'NormalBg' 		},
		ReplaceAfter        = { 'ModeReplaceBg' , 'NormalBg' 		},
		CommandAfter        = { 'ModeCommandBg' , 'NormalBg' 		},
	},
	text = function()
		if vim.o.paste then
			return {
				{ ' ', '' },
				{ sep.left_rounded, 'Paste' .. state.mode[2] .. 'After' }
			}
		else
			return {
				{ sep.right_rounded..' ', state.mode[2] .. 'After' },
			}
		end
	end,
}

basic.paste_mode = {
	hl_colors = {
		default             = { 'FileNameFg', 'FileNameBg'},
		sep_right_proj      = hl_list.PasteRightProjSep,
		sep_right_file      = hl_list.PasteRightFileSep,
		paste_mode          = { 'PasteModeFg' , 'PasteModeBg'  },
		FileNormalAfter     = { 'FileNameBg'  , 'ModeNormalBg' },
		FileInsertAfter     = { 'FileNameBg'  , 'ModeInsertBg' },
	},
	text = function()
		if vim.o.paste then
			return {
				{ 'ραstɛ', 'paste_mode', },
				{ sep.right_rounded.. ' ', 'sep_right_file' },
			}
		end
	end,
}

basic.projectname = {
	name = 'projectname',
	hl_colors = {
		sep_right     = { 'ProjectNameBg', 'FileNameBg'    },
		project       = { 'ProjectNameFg', 'ProjectNameBg' },
		sep_left      = { 'ProjectNameBg', 'NormalBg'      },
		sep_left_file = { 'FileNameBg', 'NormalBg'         },
		FileName      = { 'FileFg', 'FileBg', 'italic'     },
	},
	text = function(bufnr)
		if git_comps.is_git(bufnr) then
			return {
				{ sep.left_rounded, 'sep_left' },
				{ git_comps.git_branch({icon = ' '}), 'project' },
				-- { ' ', '' },
				{ sep.right_rounded..' ', 'sep_right' }
			}
		else
			if vim.bo.filetype == 'alpha' then
				return
			else
				return {
					{ sep.left_rounded, 'sep_left_file' },
				}
			end
		end
	end,
	click = function ()
		vim.cmd('Neogit')
	end,
	width = 75
}

--[[ basic.file_leftsep = {
	hl_colors = {
		default   = {'FileNameFg',    'FileNameBg' },
		sep_right = {'ProjectNameBg', 'NormalBg'   },
		sep_left  = {'ProjectNameBg', 'NormalBg'   },
	},
	text = function(bufnr)
		if git_comps.is_git(bufnr) then
			return {
				{ sep.right_rounded, 'sep_left' },
				{ '', 'default' },
			}
		else
			return {
				{ sep.left_rounded, 'sep_left' },
				-- { '', 'default' },
			}
		end
	end,
} ]]

local function is_file_ro()
	if vim.bo.readonly then
		return ' '
	else
		return
	end
end

local icon_comp = b_components.cache_file_icon({ default = '', hl_colors = {'FileNameFg','FileNameBg'} })
basic.file = {
	name = 'file',
	hl_colors = {
		default      = hl_list.File,
		FileName     = { 'FileFg', 'FileBg', 'italic'  },
		FileModified = { 'FileNameModFg', 'FileNameBg' },
		FileRO       = { 'FileNameROFg', 'FileNameBg'  },
		FileIcon     = hl_list.FileIcon
	},
	text = function(bufnr)
		if vim.bo.filetype == 'alpha' then
			return
		else
			return {
				-- { ' ', 'FileName' },
				icon_comp(bufnr),
				{ ' ', 'FileModified' },
				{ b_components.cache_file_name('Keine!', 'unique'), 'FileName' },
				{ b_components.file_modified('✱ '), 'FileModified' },
				{ is_file_ro(), 'FileRO' },
				{ sep.right_rounded, 'default' },
			}
		end
	end,
}

basic.file_rightsep = {
	hl_colors = {
		default  = {'FileNameBg', 'ActiveBg'},
		sep_right_file = {'FileNameBg', 'NormalBg'},
	},
	text = function()
		if vim.bo.filetype == 'alpha' then
			return
		else
			return {
				{ sep.right_rounded, 'default' },
				-- { ' ', 'default' },
			}
		end
	end,
}

basic.git = {
	name = 'git',
	hl_colors = {
		added   = hl_list.GitDiffAdded,
		changed = hl_list.GitDiffChanged,
		removed = hl_list.GitDiffRemoved
	},
	text = function(bufnr)
		if git_comps.is_git(bufnr) then
			return {
				{ '', ' ' },
				{ git_comps.diff_added({ format   = '  %s', show_zero = false  }), 'added'  },
				{ git_comps.diff_changed({ format = ' 柳%s', show_zero = false }), 'changed' },
				{ git_comps.diff_removed({ format = '  %s', show_zero = false }), 'removed' },
			}
		end
		return ''
	end,
	width = 70
}

-- Right side segment
---------------------------------------------
-- local check_lsp_status = lsp_comps.check_lsp({})
basic.lsp_diagnos = {
	name = 'diagnostic',
	hl_colors = {
		red    = { 'red'    , 'ActiveBg' },
		yellow = { 'yellow' , 'ActiveBg' },
		blue   = { 'blue'   , 'ActiveBg' },
	},
	text = function(bufnr)
		if lsp_comps.check_lsp(bufnr) then
			return {
				{ lsp_comps.lsp_hint({ format    = ' %s', show_zero = false  }), 'blue'   },
				{ lsp_comps.lsp_warning({ format = '  %s', show_zero = false }), 'yellow' },
				{ lsp_comps.lsp_error({ format   = '  %s', show_zero = false }), 'red'    },
			}
		end
		return ''
	end,
	width =	85
}

local function lsp_client_names(component)
	local clients = {}
	local icon = component.icon or ' '
	for _, client in pairs(vim.lsp.get_active_clients({bufnr = 0})) do
		if client.name ==  'jedi_language_server' then
			client.name = 'jedi'
		elseif client.name ==  'sumneko_lua' then
			client.name = 'lua'
		elseif client.name ==  'null-ls' then
			client.name = 'null'
		end
		table.insert(clients, client.name)
	end

	if next(clients) == nil then
		-- return icon .. ' Keine!'
		return nil
	else
		return icon .. '(' .. table.concat(clients, ',') .. ')'
	end
end

-- local lsp_server_name = lsp_comps.lsp_name()
basic.lsp_client = {
	hl_colors = {
		sep_before       = { 'LSPClientBg', 'NormalBg' },
		sep_before_empty = { 'FileInfoBg', 'NormalBg' },
		lsp_cl           = { 'LSPClientFg', 'LSPClientBg', 'italic' },
		sep_after        = { 'LSPClientBg', 'NormalBg' },
	},
	text = function()
		if lsp_client_names({}) ~= nil then
			return {
				{ sep.left_rounded, 'sep_before' },
				{ lsp_client_names({}), 'lsp_cl' },
				{ sep.right_rounded, 'sep_after' },
			}
		else
			return
		end
	end,
	click = function ()
		vim.cmd('LspInfo')
	end,
	width = 120
}

basic.fileinfo = {
	name = 'fileinfo',
	hl_colors = {
		sep_before = { 'FileInfoBg' , 'NormalBg'   },
		sep_after  = { 'FileInfoBg' , 'NormalBg'   },
		sep        = { 'black'      , 'FileInfoBg', 'bold' },
		file_type  = { 'FileInfoFg' , 'FileInfoBg' },
		FileIcon   = hl_list.FileIcon
	},
	text = function()
		return {
			{ ' ', 'sep_before' },
			{ sep.left_rounded, 'sep_before' },
			{ b_components.file_type(), 'file_type' },
			{'│','sep'},
			{ b_components.file_format({icon = true}), 'file_type' },
			{ ' ', '' },
			{ sep.right_rounded, 'sep_after' },
		}
	end,
	width = 75
}

basic.indent = {
	hl_colors = {
		sep_before  = { 'IndentBg',   'NormalBg'     },
		sep_after   = { 'CursorChBg', 'NormalBg'     },
		sep         = { 'black',      'IndentBg'     },
		sep1        = { 'IndentBg',   'CursorChBg'   },
		indentcolor = { 'IndentFg',   'IndentBg'     },
		charcolor   = { 'CursorChFg', 'CursorChBg'   },
	},
	text = function()
		local sw = vim.bo.shiftwidth
		local et = vim.bo.expandtab
		local im = ''
		if et == true then
			im='•'
		else
			im='▸'
		end
		return {
			{ ' ', 'sep_before' },
			{ sep.left_rounded, 'sep_before' },
			{string.format('%s%s≡', sw, im), 'indentcolor'},
			-- {'│','sep'},
			{'','sep1'},
			-- {'','sep1'},
			{ '𝒞𝒽:%02B𝒉', 'charcolor' },
			{ sep.right_rounded, 'sep_after' },
		}
	end,
	width = 70
}
--                  

basic.right = {
	hl_colors = {
		sep_before = { 'RightBg'  , 'NormalBg'         },
		sep_after  = { 'RightBg'  , 'NormalBg'         },
		text       = { 'black'    , 'RightBg'          },
		lineno     = { 'LineNoFg' , 'LineNoBg'         },
		sep        = { 'black'    , 'RightBg' , 'bold' },
	},
	text = function()
		return {
			{ ' ', 'sep_before' },
			{ sep.left_rounded, 'sep_before' },
			{ '', 'text' },
			{' %l:%v','text'},
			{'│','sep'},
			{'%p%%','text'},
			{ sep.right_rounded, 'sep_after' },
		}
	end,
}

basic.lazy = {
	hl_colors = {
		sep  = { 'RightBg', 'NormalBg' },
		text = { 'LazyFg'  , 'NormalBg'},
	},
	text = function()
		if require("lazy.status").has_updates() then
			return {
				{ ' ', 'sep' },
				{ require("lazy.status").updates(), 'text' },
				{ ' ', 'sep' },
			}
		end
	end,
}

basic.showcmd = {
	hl_colors = {
		sep  = { 'FileNameBg', 'NormalBg' },
		text = { 'LazyFg'  , 'FileNameBg'},
	},
	text = function()
		if require("noice").api.status.command.has() then
			return {
				{ sep.left_rounded, 'sep' },
				{ '⌨ ' .. require("noice").api.status.command.get() .. ' ', 'text' },
				{ '', 'sep' },
				{ ' ' .. require("lazy.status").updates(), 'text' },
				{ sep.right_rounded, 'sep' },
			}
		end
	end,
}
--                  

local default = {
	filetypes = { 'default' },
	active = {
		{ ' ', hl_list.Black },
		basic.vi_mode,
		basic.mode_rightsep,
		basic.paste_mode,
		basic.projectname,
		basic.file,
		basic.git,
		basic.divider,
		-- basic.showcmd,
		basic.divider,
		basic.lsp_diagnos,
		{ ' ', hl_list.Active },
		basic.lsp_client,
		basic.fileinfo,
		basic.indent,
		basic.right,
		{ ' ', hl_list.Black },
	},

	inactive = {
		basic.file_name_inactive,
		basic.divider,
		basic.divider,
		basic.line_col_inactive,
		{ '', { 'white', 'InactiveBg' } },
		basic.progress_inactive,
	},
}

local quickfix = {
	filetypes = { 'qf', 'Trouble' },
	active = {
		{ '🚦 Quickfix ', { 'white', 'black' } },
		{ helper.separators.slant_right, { 'black', 'black_light' } },
		{
			function()
				return vim.fn.getqflist({ title = 0 }).title
			end,
			{ 'cyan', 'black_light' },
		},
		{ ' Total : %L ', { 'cyan', 'black_light' } },
		{ helper.separators.slant_right, { 'black_light', 'InactiveBg' } },
		{ ' ', { 'InactiveFg', 'InactiveBg' } },
		basic.divider,
		{ helper.separators.slant_right, { 'InactiveBg', 'black' } },
		{ '🧛 ', { 'white', 'black' } },
	},
	always_active = true,
	show_last_status = true
}

windline.setup({
	colors_name = function(colors)
		-- Common colors
		-- colors.black_light   = "#595B83"
		-- colors.green_light   = "#99c794"
		colors.NormalFg      = "#c5cdd9"
		colors.NormalBg      = "#303244"
		colors.ActiveFg      = "#c5cdd9"
		colors.ActiveBg      = "#303244"
		colors.InActiveFg    = "#c5cdd9"
		colors.InActiveBg    = "#303244"

		-- Mode
		colors.ModeNormalFg  = "#000000"
		colors.ModeInsertFg  = "#000000"
		colors.ModeVisualFg  = "#000000"
		colors.ModeReplaceFg = "#000000"
		colors.ModeCommandFg = "#000000"

		colors.ModeNormalBg  = "#8880aC"
		colors.ModeInsertBg  = "#2AA198"
		colors.ModeVisualBg  = "#F7CAB8"
		colors.ModeReplaceBg = "#D85A93"
		colors.ModeCommandBg = "#AE8A7E"

		-- termguicolors
		colors.FileFg        = "#F4C493"
		colors.FileBg        = "#404C64"
		colors.FileNameFg    = "#FEFEFE"
		colors.FileNameBg    = "#404C64"
		colors.FileNameModFg = "#00AFDB"
		colors.FileNameROFg  = "#EC5F67"

		colors.PasteModeFg   = "#000000"
		colors.PasteModeBg   = "#db8a89"

		colors.GitAddedFg    = "#4eb899"
		colors.GitChangedFg  = "#B99AB9"
		colors.GitRemovedFg  = "#EA4050"

		colors.LSPDiagErrFg  = "#FD5866"
		colors.LSPDiagWarnFg = "#729FCF"
		colors.LSPDiagHintFg = "#9987A4"

		colors.NavicFg       = "#FEFEFE"
		colors.NavicBg       = "#984ea3"

		colors.LSPClientFg   = "#eeeeee"
		colors.LSPClientBg   = "#356088"

		colors.ProjectNameFg = "#F0F0F0"
		colors.ProjectNameBg = "#75828F"

		colors.FileInfoFg    = "#000000"
		colors.FileInfoBg    = "#94789B"

		colors.IndentFg      = "#000000"
		colors.IndentBg      = "#af7aa1"

		colors.CursorChFg    = "#eeeeee"
		colors.CursorChBg    = "#4d708c"
		colors.SearchCntFg   = "#4EB899"

		colors.LineNoFg      = "#eeeeee"
		colors.LineNoBg      = "#A070C8"
		colors.RightBg       = "#AE8A7E"

		colors.LazyFg 		 = "#4eb899"

		return colors
	end,

	statuslines = {
		default,
		quickfix,
	},
})

vim.opt.laststatus = 3
end

return M
--                  

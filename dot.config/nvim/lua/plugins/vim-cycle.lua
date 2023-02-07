
local M = {
		'bootleq/vim-cycle',
		-- event = 'VeryLazy',
		keys = { '-', '+' }
}

function M.config()
	local options = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "+", "<Plug>CycleNext", options)
	vim.api.nvim_set_keymap("n", "-", "<Plug>CyclePrev", options)

	vim.g.cycle_default_groups_for_c = {
		{ '>>', '<<'   },
		{ '=>>', '<<=' },
		{ '&&', '||'   },
		{ '>=', '<='   },
		{ '->', '.'    },
	}

	vim.g.cycle_default_groups_for_sh = {
		{ 'eq', 'gt', 'lt', 'le', 'ge' },
		{ '&&'  , '||'  },
		{ '>='  , '<='  },
		{ '>>'  , '<<'  },
		{ '=>>' , '<<=' },
		{ '-n'  , '-z'  },
	}

	vim.g.cycle_default_groups_for_gitrebase = {
		{ 'pick', 'fixup', 'reword', 'edit', 'squash', 'drop' },
	}

	vim.g.cycle_default_groups = {
		{ 'true'    , 'false' },
		{ 'yes'     , 'no'    },
		{ 'on'      , 'off'   },
		{ 'allow'   , 'deny'  },
		{ 'before'  , 'after' },
		{ 'block'   , 'inline', 'none' } ,
		{ 'define'  , 'undef'   },
		{ 'good'    , 'bad'     },
		{ 'in'      , 'out'     },
		{ 'left'    , 'right'   },
		{ 'min'     , 'max'     },
		{ 'on'      , 'off'     },
		{ 'start'   , 'stop'    },
		{ 'enable'  , 'disable' },
		{ 'success' , 'failure' },
		{ 'up'      , 'down'    },
		{ 'left'    , 'right'   },
		{ 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday' },
		{ 'january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december' },
		{ '0', '1' },
		{ '+', '-' },
		{ '}', '{' },
		{ ')', '(' },
		{ ']', '[' },
		{ '>', '<' },
		{ '&', '|' },
		{'==', '!='},
	}
end
return M

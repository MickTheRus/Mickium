local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local windowpicker = require("window-picker")
local builtin = require("telescope.builtin")


telescope.setup({
	defaults = {
		history = {
			path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
			limit = 100,
		},
		prompt_prefix = "Telescope",
		selection_caret = "ChevronRight",
		path_display = { "truncate" },
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		dynamic_preview_title = true,

		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},

		mappings = {
			i = {
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<ESC>"] = "close",
			},
			n = {
				q = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = { "fd", "--type=file", "--hidden", "--exclude=.git", "--strip-cwd-prefix" },
		},
		lsp_references = {
			get_selection_window = function()
				return windowpicker.pick_window() or vim.api.nvim_get_current_win()
			end,
		},
	},

	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
		file_browser = {
			theme = "dropdown",
			hijack_netrw = false,
			path = "%:p:h",

			get_selection_window = function()
				return windowpicker.pick_window() or vim.api.nvim_get_current_win()
			end,

			mappings = {
				i = {
					["<C-c>"] = telescope.extensions.file_browser.actions.create_from_prompt,
					["<ESC>"] = false,
				},
			},
		},
		["ui-select"] = {
			themes.get_cursor(),
		},
		aerial = {
			show_nesting = {
				["_"] = false,
				json = true,
				yaml = true,
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("refactoring")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("smart_history")
telescope.load_extension("harpoon")
telescope.load_extension("aerial")


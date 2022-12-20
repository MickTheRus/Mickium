local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local builtin = require("telescope.builtin")


telescope.setup({
	defaults = {
		prompt_prefix = "TElescope",
		selection_caret = ">",
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
	},

	extensions = {
		file_browser = {
			theme = "dropdown",
			hijack_netrw = false,
			path = "%:p:h",

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

telescope.load_extension("ui-select")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("harpoon")
telescope.load_extension("aerial")

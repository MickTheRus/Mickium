local i = require("icons")
local git_blame = require("gitblame")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = {
		error = i.Error,
		warn = i.Warning,
	},
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = {
		added = i.Add,
		modified = i.Mod,
		removed = i.Remove,
	}, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		local modes = {
			INSERT = "列",
			["O-PENDING"] = "",
			NORMAL = "",
			VISUAL = "",
			["V-LINE"] = "",
			["V-BLOCK"] = "",
			SELECT = "",
			["S-LINE"] = "",
			["S-BLOCK"] = "",
			REPLACE = "列",
			["V-REPLACE"] = "列",
			COMMAND = "",
			EX = "",
			MORE = "",
			CONFIRM = "",
			SHELL = "",
			TERMINAL = "",
		}
		return "     " .. modes[str] .. " "
	end,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = i.Branch,
}

local location = {
	"location",
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

vim.g.gitblame_display_virtual_text = 0

local fileicon = {
	"filetype",
	icon_only = true,
}

local filename = {
	"filename",
	path = 0,

	symbols = {
		modified = i.Circle, -- Text to show when the file is modified.
		readonly = i.Lock, -- Text to show when the file is non-modifiable or readonly.
		unnamed = "[No Name]", -- Text to show for unnamed buffers.
		newfile = "[New]", -- Text to show for new created file before first writting
	},
}

local winbar = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {
		fileicon,
		filename,
		{
			"aerial",
		},
	},
	lualine_x = {},
	lualine_y = {},
	lualine_z = {},
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "dracula",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = { "NvimTree", "aerial" },
		},
		always_divide_middle = true,
		globalstatus = true,
	},
	winbar = winbar,
	inactive_winbar = winbar,
	sections = {
		lualine_a = {
			branch,
			diagnostics,
		},
		lualine_b = { mode },
		lualine_c = {
			fileicon,
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }, diff },
		lualine_y = { spaces, location },
		lualine_z = { progress },
	},
	extensions = { "quickfix", "toggleterm", "nvim-tree", "aerial" },
})
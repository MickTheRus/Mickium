local M = {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"ahmedkhalf/project.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvim tree" },
		{ "<C-h>", "<cmd>NvimTreeFocus<cr>", desc = "Focus tree" },
	},
}

function M.config()
	require("project_nvim").setup({
		active = true,
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
	})

	require("nvim-tree").setup({
		view = {
			width = 20,
			side = "left",
			hide_root_folder = true,
		},
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = false,
        },
		disable_netrw = true,
		hijack_cursor = true,
		update_cwd = true,
		renderer = {
			indent_markers = {
				enable = true,
			},
			icons = {
				webdev_colors = false,
				show = {
					file = false,
					folder = true,
					folder_arrow = false,
					git = true,
				},
			},
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		git = {
			enable = true,
			ignore = false,
			timeout = 400,
		},
	})
end

return M

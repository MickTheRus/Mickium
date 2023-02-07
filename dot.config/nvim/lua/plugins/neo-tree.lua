local M = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", {desc = "Project Explorer"} },
	},
}

  function M.config()
	vim.g.neo_tree_remove_legacy_commands = 1
    require("neo-tree").setup({
      window = {
        width = "30",
      },
    })
  end

return M

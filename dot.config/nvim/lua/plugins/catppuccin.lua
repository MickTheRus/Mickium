---@type LazyPluginSpec[]

local M = {
  "catppuccin/nvim",
  as = "catppuccin",

  lazy = false,
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        harpoon = true,
        illuminate = true,
        mason = true,
        mini = true,
        neogit = true,
        noice = true,
        notify = true,
        symbols_outline = true,
        telekasten = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
return M

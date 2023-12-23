local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

function M.config()
  local catppuccin = require "catppuccin"

  catppuccin.setup {
    transparent_background = false,
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
      },
    },
  }
  vim.cmd.colorscheme "catppuccin-mocha"
end

return M

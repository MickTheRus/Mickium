local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.icons",
  },
}

function M.config()
  require "nvim-web-devicons"
end

return M

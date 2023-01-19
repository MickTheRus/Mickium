---@type LazyPluginSpec[]
local M = {
      "linty-org/key-menu.nvim",
config = function ()
  require("key-menu").set("", "<Space>")
  require("key-menu").set("n", "<leader>t", { desc = "Telescope" })
  require("key-menu").set("n", "<leader>p", { desc = "Lazy" })
  require("key-menu").set("n", "<leader>g", { desc = "Git" })
  require("key-menu").set("n", "<leader>d", { desc = "Debug" })
  require("key-menu").set("n", "<leader>b", { desc = "Buffers" })
  require("key-menu").set("n", "<leader>l", { desc = "LSP" })
end
}
return M
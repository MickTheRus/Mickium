local copilot = require("copilot")

vim.defer_fn(function()
  copilot.setup({
    copilot_node_command = "node",
  })
end, 100)

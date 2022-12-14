local km = require("key-menu")
local keymap = vim.keymap.set

local opts = { silent = true }

vim.keymap.set("n","<Space>",function()
  km.open_window("<Space>")
end)

keymap("n","<Space>e","<cmd>NvimTreeToggle<cr>",{desc="File Explorer"},opts)

-- Telescope
keymap("n", "<Space>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<Space>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<Space>fp", ":Telescope projects<CR>", opts)
keymap("n", "<Space>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<Space>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<Space>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<Space>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
keymap("n", "<Space>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<Space>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<Space>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<Space>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<Space>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<Space>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<Space>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<Space>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<Space>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- Lsp
keymap("n", "<Space>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

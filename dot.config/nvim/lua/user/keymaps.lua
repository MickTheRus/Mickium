local km = require("key-menu").set

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

km("n", "<leader>")
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear Highlights" }, opts)

-- Buffers buffers
km("n", "<leader>b", { desc = "Buffers" }, opts)
keymap("n", "<leader>bd", "<cmd>Bdelete!<CR>", { desc = "Close" }, opts)
keymap("n", "<leader>bs", "<cmd>w!<CR>", { desc = "Save" }, opts)
keymap("n", "<leader>bS", "<cmd>SudaWrite<CR>", { desc = "Sudo Save" }, opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--- Plugins ---

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File Explorer" }, opts)

-- Telescope
km("n", "<leader>f", { desc = "Telescope" }, opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" }, opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", { desc = "Find Text" }, opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Projects" }, opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" }, opts)

-- Git
km("n", "<leader>g", { desc = "Git" })
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "Comment" }, opts)

-- Packer
km("n", "<leader>p", { desc = "Packer" }, opts)
keymap("n", "<leader>pS", "<cmd>PackerStatus<CR>", { desc = "Status" }, opts)
keymap("n", "<leader>pc", "<cmd>PackerCompile<CR>", { desc = "Compile" }, opts)
keymap("n", "<leader>pi", "<cmd>PackerInstall<CR>", { desc = "Install" }, opts)
keymap("n", "<leader>ps", "<cmd>PackerSync<CR>", { desc = "Sync" }, opts)
keymap("n", "<leader>pu", "<cmd>PackerUpdate<CR>", { desc = "Update" }, opts)
keymap("n", "<leader>pr", "<cmd>so %<CR>", { desc = "Source Current File" }, opts)

-- DAP
km("n", "<leader>d", { desc = "Debug" }, opts)
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Breakpoint" }, opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", { desc = "Continue" }, opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Into" }, opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Over" }, opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", { desc = "Out" }, opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", { desc = "Repl" }, opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "Last" }, opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", { desc = "Dap UI" }, opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", { desc = "Exit" }, opts)

-- Lsp
km("n", "<leader>l", { desc = "LSP" }, opts)
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { desc = "Format" }, opts)
keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Info" }, opts)
keymap("n", "<leader>lI", "<cmd>Mason<cr>", { desc = "Installer Info" }, opts)
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" }, opts)
keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", { desc = "Next Diagnostic" }, opts)
keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", { desc = "Prev Diagnostic" }, opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" }, opts)
keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature" }, opts)
keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "Quickfix" }, opts)
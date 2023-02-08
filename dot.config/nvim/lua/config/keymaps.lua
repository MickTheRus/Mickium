local gitsigns = require('gitsigns')

local function map(mode, new_keys, to_do, options)
  local keymap = vim.keymap.set
  local default_options = {
    noremap = true,
    silent = true,
    expr = false,
  }
  if options then
    default_options = vim.tbl_extend('force', default_options, options)
  end
  local ok, _ = pcall(keymap, mode, new_keys, to_do, default_options)
  if not ok then
    local msg = 'Fail to map ' .. new_keys .. ' for ' .. to_do
    vim.notify(msg, vim.log.levels.ERROR, {
      title = 'Keymap',
    })
  end
end

map("n", "<Esc>", "<cmd>noh<CR>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<Cmd>e #<CR>")
map("n", "gV", "`[v`]")

map('i', '<S-CR>', '<C-o>o')

map('x', '<', '<gv')
map('x', '>', '>gv|')
map('x', '<S-TAB>', '<gv')
map('x', '<TAB>', '>gv|')

map("n", "<Leader>w", "<cmd>w<CR>")
map("n", "<Leader>x", "<cmd>x<CR>")
map("n", "<Leader>X", "<cmd>xall<CR>")
map({ "n", "x" }, "<Leader>;", ":", { desc = "Enter Cmd Mode" })
-- map("n", "<BS>", "<cmd>nohlsearch<CR>")
-- map("n", "<BS>", "V")
map("n", "<Leader><BS>", "<C-V>", { desc = "Enter Visual Block Mode" })
map("n", "<Leader><Space>", "V", { desc = "Enter Visual Mode" })
-- map("n" , "<A-d>", "<cmd>bdelete<CR>", { desc = "Delete Current Buf" })

map("n", "<A-o>", "<cmd>call append(line('.')   , '')<CR>")
map("n", "<A-O>", "<cmd>call append(line('.')-1 , '')<CR>")
map("n", "<F2>", "<cmd>echomsg expand('%:p')<CR>")

map("n", "<A-x>", "<C-x>")
map("n", "<A-a>", "<C-a>")
map("n", "<S-t", "<cmd>enew<CR>")
map("n", "<C-t>b", "<cmd>tabnew<CR>")

map("n", "J", "mzJ`z")
map("n", "k", "(v:count > 5 ? (\"m'\" . v:count1) : \"\") . (v:count || mode(1)[0:1] == \"no\" ? \"\" : \"g\") . \"k\"",
	{ expr = true })
map("n", "j", "(v:count > 5 ? (\"m'\" .v:count1) : \"\") . (v:count || mode(1)[0:1] == \"no\" ? \"\" : \"g\") . \"j\"",
	{ expr = true })
map("n", "<leader>k", ":m .-2<CR>==")
map("n", "<leader>j", ":m .+1<CR>==")
map("i", "<C-k>", "<Esc>:m .-2<CR>==")
map("i", "<C-j>", "<Esc>:m .+1<CR>==")

map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

-- tagbar
map("n", "<f4>", "<cmd>lua require('lsp-inlayhints').toggle()<CR>")

map("n", "<F3>", "<cmd>TroubleToggle<CR>")
map("n", "gR", "<cmd>TroubleToggle lsp_references<CR>")
map("n", "<C-A-j>", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>")
map("n", "<C-A-k>", "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>")

-- map({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })

-- map('n', '<leader>H', '<cmd>Startify<CR>')
map('n', '<leader>H', '<cmd>Alpha<CR>')

-- Undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

map({ "i", "s" }, "<C-l>", "<cmd>lua require('luasnip').jump(1)<CR>")
map({ "i", "s" }, "<C-h>", "<cmd>lua require('luasnip').jump(-1)<CR>")

--[[ map({ "i", "s" }, "<C-l>", "<Plug>(vsnip-jump-next)")
map({ "i", "s" }, "<C-h>", "<Plug>(vsnip-jump-prev)") ]]

map({ "n", "x" }, "<leader>s", "<Plug>(sqls-execute-query)", { desc = "Exec SQL Query" })

map("n", "<leader>d", '<cmd>lua require"popui.diagnostics-navigator"()<CR>')
map("n", "<leader>m", '<cmd>lua require"popui.marks-manager"()<CR>')

-- gitsigns
vim.api.nvim_create_user_command("Stage", function(t) gitsigns.stage_hunk({ t.line1, t.line2 }) end, { range = true })
vim.api.nvim_create_user_command("Reset", function(t) gitsigns.reset_hunk({ t.line1, t.line2 }) end, { range = true })

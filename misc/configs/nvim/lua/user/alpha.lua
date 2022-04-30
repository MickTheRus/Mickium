local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local icons = require "user.icons"

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
[[███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗]],
[[████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║]],
[[██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║]],
[[██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║]],
[[██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║]],
[[╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", icons.documents.Files .. "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button(
    "p",
    icons.git.Repo .. " Find project",
    ":lua require('telescope').extensions.projects.projects()<CR>"
  ),
  dashboard.button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", icons.ui.List .. "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("s", icons.ui.SignIn .. "  Find Session", ":Telescope sessions save_current=false <CR>"),
  dashboard.button("c", icons.ui.Gear .. "  Config", ":e ~/.config/nvim <CR>"),
  dashboard.button("q", icons.diagnostics.Error .. "  Quit", ":qa<CR>"),
}
local function footer()
  -- NOTE: requires the fortune-mod package to work
  -- local handle = io.popen("fortune")
  -- local fortune = handle:read("*a")
  -- handle:close()
  -- return fortune
  return "retards@home"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

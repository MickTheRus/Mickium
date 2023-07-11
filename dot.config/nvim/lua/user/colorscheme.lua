local M = {
	"catppuccin/nvim",
  name = "catppuccin",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "catppuccin-mocha"
function M.config()
	local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
	if not status_ok then
		return
	end
end

return M

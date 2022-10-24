local wezterm = require("wezterm")
local current = require("current")

return {
	font = wezterm.font("Iosevka Nerd Font"),
	colors = current,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
}

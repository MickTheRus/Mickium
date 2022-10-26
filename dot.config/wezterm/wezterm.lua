local wezterm = require("wezterm")
local current = require("current")
local act = wezterm.action

return {
	font = wezterm.font("Iosevka Nerd Font"),
	colors = current,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,

	keys = {
		{ key = "i", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
	},
}

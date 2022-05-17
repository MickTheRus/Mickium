local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
beautiful.init(require("theme"))

require("layout")

require("module.auto-start")
require("module.decorate-client")

require("configuration.client")
require("configuration.tags")

_G.root.keys(require("configuration.keys.global"))

screen.connect_signal("property::geometry", function(s)
	beautiful.wallpaper.maximized(beautiful.wallpaper, s, beautiful.wallpapers)
end)

_G.client.connect_signal("manage", function(c)
	if not _G.awesome.startup then
		awful.client.setslave(c)
	end

	if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- autorun = true
-- autorunApps =
-- {
--     'nm-applet --indicator', -- wifi
--     'pasystray', -- shows an audiocontrol applet in systray when installed.
--     'numlockx on', -- enable numlock
--     '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
--     'xfce4-power-manager', -- Power manager
--     'flameshot',
--     '/usr/bin/variety',
--     '~/.config/awesome/configuration/utils/awspawn', -- Spawn "dirty" apps that can linger between sessions
--     'sh ~/.config/awesome/configuration/utils/set_wallpaper.sh',
-- }
-- if autorun then
--    for app = 1, #autorunApps do
--        awful.util.spawn(autorunApps[app])
--    end
-- end

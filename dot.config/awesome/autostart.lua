local awful = require("awful")

local autorun = true
local autorunApps = {
	"picom",
	"/usr/libexec/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)",
  "flameshot"
}
if autorun then
	for app = 1, #autorunApps do
		awful.util.spawn(autorunApps[app])
	end
end

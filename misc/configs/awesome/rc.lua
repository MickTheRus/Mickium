local gears = require('gears')
local awful = require('awful')
local wibox = require("wibox")
require('awful.autofocus')
local beautiful = require('beautiful')
-- local beautiful = require('widget.menu')
-- Theme
beautiful.init(require('theme'))


-- Layout
require('layout')

-- Init all modules
-- require('module.notifications')
require('module.auto-start')
require('module.decorate-client')

-- Setup all configurations
require('configuration.client')
require('configuration.tags')


_G.root.keys(require('configuration.keys.global'))

-- {{{ Screen
-- Reset wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal( "property::geometry", function(s) beautiful.wallpaper.maximized( beautiful.wallpaper, s, beautiful.wallpapers) end )

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

autorun = true
autorunApps =
{
    'nm-applet --indicator', -- wifi
    'pasystray', -- shows an audiocontrol applet in systray when installed.
    'numlockx on', -- enable numlock
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xfce4-power-manager', -- Power manager
    'flameshot', 
    '/usr/bin/variety',
    '~/.config/awesome/configuration/utils/awspawn', -- Spawn "dirty" apps that can linger between sessions
    'sh ~/.config/awesome/configuration/utils/set_wallpaper.sh',
}
if autorun then
   for app = 1, #autorunApps do
       awful.util.spawn(autorunApps[app])
   end
end

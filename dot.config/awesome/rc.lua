--# vim:fileencoding=utf-8:foldmethod=marker
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM voidwaand other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local theme = require("theme")

-- Error handling {{{
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = "nvim" or os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile.left,
	awful.layout.suit.floating,
	awful.layout.suit.max,

}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual",      terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart",     awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu =
	awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon }, { "open terminal", terminal } } })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local widget_fg = "#a6adc8"
local widget_bg = "#313244"

---------------------------------
-- Cutom Widgets
---------------------------------

-- Storage widget
local container_storage_widget = wibox.container

local storage_widget_root = wibox.widget({
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local update_storage_root = function(st_root)
	storage_widget_root.text = " " .. st_root
end

local storage_widget_home = wibox.widget({
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local update_storage_home = function(st_home)
	storage_widget_home.text = " " .. st_home
end

local storage_root = awful.widget.watch("bash -c \"df -h | awk 'NR==4 {print $4}'\"", 60, function(self, stdout)
	local st_root = stdout
	update_storage_root(st_root)
end)

local storage_home = awful.widget.watch("disk-usage.sh", 60, function(self, stdout)
	st_home = stdout
	update_storage_home(st_home)
end)

container_storage_widget = {
	{
		{
			{
				{
					{
						widget = storage_widget_root,
					},
					{
						widget = storage_widget_home,
					},
					layout = wibox.layout.flex.horizontal,
				},
				left = 5,
				right = 5,
				top = 2,
				bottom = 2,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_bar,
			fg = "#b4befe",
			bg = widget_bg,
			forced_width = 140,
			widget = wibox.container.background,
		},
		left = 10,
		right = 5,
		top = 7,
		bottom = 7,
		widget = wibox.container.margin,
	},
	spacing = 5,
	layout = wibox.layout.fixed.horizontal,
}
-- Brightness widget
local container_brightness_widget = wibox.container

local brightness_widget = wibox.widget({
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

-- Volume widget
local container_vol_widget = wibox.container

local vol_widget = wibox.widget({
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local update_vol_widget = function(vol)
	vol_widget.text = "  " .. vol
end

local vo, vo_signal = awful.widget.watch("volume-bar.sh", 60, function(self, stdout)
	local vol = stdout
	update_vol_widget(vol)
end)

container_vol_widget = {
	{
		{
			{
				{
					widget = vol_widget,
				},
				left = 12,
				right = 12,
				top = 0,
				bottom = 0,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_bar,
			fg = "#f38ba8",
			bg = widget_bg,
			widget = wibox.container.background,
		},
		left = 5,
		right = 5,
		top = 7,
		bottom = 7,
		widget = wibox.container.margin,
	},
	spacing = 5,
	layout = wibox.layout.fixed.horizontal,
}
-- Clock widget
container_arch_widget = {
	{
		{
			text = "  ",
			font = "Iosevka Nerd Font 15",
			widget = wibox.widget.textbox,
		},
		left = 0,
		right = 5,
		top = 2,
		bottom = 2,
		widget = wibox.container.margin,
	},
	fg = "#fab387",
	widget = wibox.container.background,
}

-- Clock widget
container_clock_widget = {
	{
		{
			{
				{
					widget = mytextclock,
				},
				left = 6,
				right = 6,
				top = 0,
				bottom = 0,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_bar,
			fg = "#b4befe",
			bg = widget_bg,
			widget = wibox.container.background,
		},
		left = 5,
		right = 5,
		top = 7,
		bottom = 7,
		widget = wibox.container.margin,
	},
	spacing = 5,
	layout = wibox.layout.fixed.horizontal,
}

local archimage = wibox.widget({
	image = theme.layout_archlogo,
	resize = false,
	widget = wibox.widget.imagebox,
})

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag(
		{ " ", " ", " ", " ", " ", " ", " ", " ", " " },
		s,
		awful.layout.layouts[1]
	)

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	local layoutbox = wibox.widget({
		s.mylayoutbox,
		top = 5,
		bottom = 6,
		left = 5,
		right = 10,
		widget = wibox.container.margin,
	})
	s.mytaglist = require("my_taglist")(s)

-- the systray has its own internal background because of X11 limitations
beautiful.bg_systray = "#1E1E2E"
beautiful.systray_icon_spacing = 2

local my_round_systray = wibox.widget {
    {
        wibox.widget.systray(),
        left   = 5,
        top    = 1,
        bottom = 1,
        right  = 5,
        widget = wibox.container.margin,
    },
    bg         = "#1E1E2E",
    shape      = gears.shape.rounded_rect,
    shape_clip = true,
    widget     = wibox.container.background,
}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		style = {
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						{
							id = "text_role",
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					left = 10,
					right = 10,
					top = 0,
					bottom = 0,
					widget = wibox.container.margin,
				},
				fg = widget_fg,
				bg = widget_bg,
				shape = gears.shape.rounded_bar,
				widget = wibox.container.background,
			},
			left = 0,
			right = 0,
			top = 7,
			bottom = 7,
			widget = wibox.container.margin,
		},
	})

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		border_width = 0,
		border_color = "#",
		height = 30,
		input_passthrough = true,
		screen = s,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				container_arch_widget,
				layout = wibox.layout.fixed.horizontal,
				--mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			{
				-- Middle widgets
				layout = wibox.layout.fixed.horizontal,
1122			},
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				container_storage_widget,
				container_vol_widget,
				container_clock_widget,
        my_round_systray,
			},
		},
		top = 0, -- don't forget to increase wibar height
		color = "#80aa80",
		widget = wibox.container.margin,
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{
			-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			-- Middle
			{
				-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			-- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

require("autostart")
require("keymaps")
require("rules")
-- }}}

-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
local ruled = require("ruled")
local dpi = beautiful.xresources.apply_dpi

-- {{{ Notifications

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 2
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.border_width = 0
beautiful.notification_spacing = 16

local function create_notif(n)
	local icon_visibility

	if n.icon == nil then
		icon_visibility = false
	else
		icon_visibility = true
	end

	-- Action widget
	local action_widget = {
		{
			{
				id = "text_role",
				align = "center",
				font = "Iosevka Nerd Font 10",
				widget = wibox.widget.textbox,
			},
			margins = { left = dpi(3), right = dpi(3) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
	}

	-- Apply action widget ^
	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(20),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = action_widget,
		widget = naughty.list.actions,
	})

	local function space_h(length, circumstances)
		return wibox.widget({
			forced_width = length,
			visible = circumstances,
			layout = wibox.layout.fixed.horizontal,
		})
	end

	-- Make other widgets
	local title = wibox.widget.textbox()
	title.font = "Iosevka Nerd Font 12"
	title.align = "center"
	title.markup = n.title

	local message = wibox.widget.textbox()
	message.font = "Iosevka Nerd Font 12"
	message.align = "left"
	message.markup = n.message

	local icon = wibox.widget({
		nil,
		{
			{
				image = n.icon,
				visible = icon_visibility,
				widget = wibox.widget.imagebox,
			},
			strategy = "max",
			width = dpi(115),
			height = dpi(115),
			widget = wibox.container.constraint,
		},
		expand = "none",
		layout = wibox.layout.align.vertical,
	})

	local container = wibox.widget({
		{
			title,
			{
				icon,
				space_h(dpi(25), icon_visibility),
				message,
				layout = wibox.layout.fixed.horizontal,
			},
			actions,
			spacing = dpi(20),
			layout = wibox.layout.fixed.vertical,
		},
		margins = dpi(15),
		widget = wibox.container.margin,
	})

	naughty.layout.box({
		notification = n,
		type = "notification",
		bg = beautiful.bg,
		border_width = 0,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 5)
		end,
		widget_template = {
			{
				{
					{
						widget = container,
					},
					strategy = "max",
					width = dpi(300),
					height = dpi(200),
					widget = wibox.container.constraint,
				},
				strategy = "min",
				width = dpi(300),
				height = dpi(130),
				widget = wibox.container.constraint,
			},
			bg = beautiful.bg,
			widget = wibox.container.background,
		},
	})
end

naughty.connect_signal("request::display", function(n)
	create_notif(n)
end)

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.focused(),
			implicit_timeout = 4,
		},
	})
end)

-- }}}
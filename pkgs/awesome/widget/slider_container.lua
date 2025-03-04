local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local slider = require("widget.slider")
local button = require("widget.button")

function create_slider_container(button_icon_name, button_cmd, slider, slider_title)
	local button = create_button(button_icon_name, button_cmd)
	local slider_line = {
		{
			button,
			widget = wibox.container.margin,
			top = 0,
			bottom = dpi(10),
			right = 0,
			left = dpi(5),
		},
		{
			slider,
			widget = wibox.container.margin,
			top = dpi(1),
			bottom = dpi(10),
			right = dpi(15),
			left = dpi(5),
			forced_width = dpi(360),
			forced_height = dpi(70),
		},
		layout = wibox.layout.fixed.horizontal,
		forced_width = dpi(410),
		forced_height = dpi(50),
	}

	local slider_textbox = wibox.widget({
		{
			markup = '<span color="'
				.. beautiful.base02
				.. '" font="Ubuntu Nerd Font bold 11">'
				.. slider_title
				.. "</span>",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.margin,
		top = dpi(10),
		bottom = dpi(12),
		right = dpi(8),
		left = dpi(8),
	})

	local slider_container = wibox.widget({
		{
			{
				{
					{
						slider_textbox,
						slider_line,
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.margin,
					top = dpi(3),
					bottom = dpi(6),
					left = dpi(2),
					right = 0,
				},
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.margin,
			top = dpi(3),
			bottom = dpi(3),
			right = dpi(3),
			left = dpi(3),
		},
		widget = wibox.container.background,
		bg = beautiful.base01,
		forced_height = dpi(100),
		forced_width = dpi(305),
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,
	})

	return slider_container
end

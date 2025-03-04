local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

function create_slider()
	local slider = wibox.widget({
		bar_shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 25)
		end,
		bar_height = dpi(20),
		bar_color = "#a9b1d6",
		bar_active_color = beautiful.base0C,
		handle_color = beautiful.base09,
		handle_border_color = beautiful.base0A,
		handle_shape = gears.shape.circle,
		handle_border_width = 1,
		maximum = 100,
		minimum = 0,
		value = 50,
		widget = wibox.widget.slider,
	})

	return slider
end

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

function create_upper_button_container(button1, button2, button3, button4)
    local vertical_separator = wibox.widget {
        orientation = 'vertical',
        forced_height = dpi(1.5),
        forced_width = dpi(1.5),
        span_ratio = 0.55,
        widget = wibox.widget.separator,
        color = "#a9b1d6",
        border_color = "#a9b1d6",
        opacity = 0.55
    }

    local upper_button_inner_container = {
        {
            button1,
            widget = wibox.container.margin,
            top = 0,
            bottom = 0,
            right = dpi(5),
            left = dpi(5)
        },
        {
            button2,
            widget = wibox.container.margin,
            top = 0,
            bottom = 0,
            right = dpi(5),
            left = dpi(5)
        },
        vertical_separator,
        {
            button3,
            widget = wibox.container.margin,
            top = 0,
            bottom = 0,
            right = dpi(5),
            left = dpi(5)
        },
        {
            button4,
            widget = wibox.container.margin,
            top = 0,
            bottom = 0,
            right = dpi(5),
            left = dpi(5)
        },
        layout = wibox.layout.fixed.horizontal,
        forced_width = dpi(100),
    }

    local upper_button_container = wibox.widget {
		{
			{
				{
					{
						upper_button_inner_container,
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.margin,
					top = dpi(3),
					bottom = dpi(3),
					left = dpi(2),
					right = 0,
				},
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.margin,
			top = dpi(3),
			bottom = dpi(3),
			right = dpi(3),
			left = dpi(3),
		},
		widget = wibox.container.background,
		bg = beautiful.base01,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,
	}

return upper_button_container
end
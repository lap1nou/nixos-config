local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

function create_button(icon_name, cmd)
    local button = wibox.widget {
        {
            {
                image = beautiful.dir .. "/icons/wibar/control_panel/" .. icon_name,
                widget = wibox.widget.imagebox,
                resize = true,
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 20)
                end,
            },
            widget = wibox.container.margin,
            top = dpi(8),
            bottom = dpi(8),
            right = dpi(13),
            left = dpi(11),
            forced_height = dpi(40)
        },
        widget = wibox.container.background,
        bg = theme.base02,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
    }

    button:connect_signal("mouse::enter", function()
        button.bg = theme.base0C
    end)

    button:connect_signal("mouse::leave", function()
        button.bg = theme.base02
    end)

    button:connect_signal("button::release", function()
        button.bg = theme.base02
    end)

    button:connect_signal("button::press", function()
        button.bg = theme.base04
        awful.spawn.with_shell(cmd)
    end)

    return button
end

function create_button_with_color(icon_name, cmd, normal_color, mouse_entered_colour, button_press_colour)
    local button = wibox.widget {
        {
            {
                image = beautiful.dir .. "/icons/wibar/control_panel/" .. icon_name,
                widget = wibox.widget.imagebox,
                resize = true,
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 20)
                end,
            },
            widget = wibox.container.margin,
            top = dpi(8),
            bottom = dpi(8),
            right = dpi(13),
            left = dpi(11),
            forced_height = dpi(40)
        },
        widget = wibox.container.background,
        bg = normal_color,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
    }

    button:connect_signal("mouse::enter", function()
        button.bg = mouse_entered_colour
    end)

    button:connect_signal("mouse::leave", function()
        button.bg = normal_color
    end)

    button:connect_signal("button::release", function()
        button.bg = normal_color
    end)

    button:connect_signal("button::press", function()
        button.bg = button_press_colour
        awful.spawn.with_shell(cmd)
    end)

    return button
end
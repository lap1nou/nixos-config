local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local slider = require("widget.slider")
local button = require("widget.button")
local upper_button_container = require("widget.upper_button_container")
local slider_container = require("widget.slider_container")
local dpi = beautiful.xresources.apply_dpi

local function run_shell(cmd)
	awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code) end)
end

local control_panel_button = wibox.widget({
	{
		id = "icon",
		widget = wibox.widget.imagebox,
		image = beautiful.dir .. "/icons/wibar/control_panel/control_panel.svg",
		align = "center",
		valign = "center",
	},
	widget = wibox.container.margin,
	margins = 4,
})

local volume_slider = create_slider()
volume_slider:connect_signal("property::value", function()
	local volume = volume_slider.value
	run_shell("amixer set Master " .. volume .. "%")
end)
local volume_container = create_slider_container("volume.svg", "pavucontrol", volume_slider, "Volume")

local brightness_slider = create_slider()
brightness_slider:connect_signal("property::value", function()
	local brightness = brightness_slider.value
	run_shell("brightnessctl s " .. brightness .. "%")
end)
local brightness_container = create_slider_container("brightness.svg", "firefox", brightness_slider, "Brightness")

local button_network = create_button("network.svg", "nm-connection-editor")
local button_exegol = create_button("exegol.svg", "rofi-exegol-start")
local button_poweroff = create_button_with_color("power_off.svg", "systemctl poweroff", "#c40029", "#c4abb0", "#f5cad3")
local button_lock = create_button_with_color("lock.svg", "physlock -s", "#af8400", "#af9444", "#afa78f")
local upper_button_container =
	create_upper_button_container(button_network, button_exegol, button_poweroff, button_lock)

local settings_popup = awful.popup({
	screen = s,
	widget = wibox.container.background,
	placement = function(c)
		awful.placement.top_right(c, { margins = { top = dpi(43), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	bg = "#00000000",
	ontop = true,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1,
})

settings_popup:setup({
	{
		{
			{
				upper_button_container,
				widget = wibox.container.margin,
				top = dpi(11),
				bottom = dpi(11),
				right = dpi(11),
				left = dpi(11),
			},
			layout = wibox.layout.flex.horizontal,
		},
		{
			volume_container,
			widget = wibox.container.margin,
			top = dpi(11),
			bottom = dpi(11),
			right = dpi(11),
			left = dpi(11),
		},
		{
			brightness_container,
			widget = wibox.container.margin,
			top = dpi(11),
			bottom = dpi(11),
			right = dpi(11),
			left = dpi(11),
		},
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.background,
	bg = beautiful.base00,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
})

local function toggle_popup()
	settings_popup.visible = not settings_popup.visible
end

control_panel_button:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		toggle_popup()
	end
end)

return control_panel_button

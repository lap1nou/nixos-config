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

-- Applications
local SOUND_APP = "amixer"
local SOUND_CONTROL_APP = "pavucontrol"
local BRIGHGTNESS_APP = "brightnessctl"
local NETWORK_APP = "nm-connection-editor"
local BLUETOOTH_APP = "blueman-manager"

local REGEX_VOLUME = "(%d?%d?%d)%%"

local function run_shell(cmd)
	awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code) end)
end

local function set_volume_slider(volume_slider)
	awful.spawn.easy_async_with_shell(SOUND_APP .. " get Master", function(stdout, stderr, reason, exit_code)
		volume = tonumber(stdout:match(REGEX_VOLUME))

		if volume ~= nil then
			volume_slider.value = volume
		end
	end)
end

local function set_microphone_slider(microphone_slider)
	awful.spawn.easy_async_with_shell(SOUND_APP .. " get Capture", function(stdout, stderr, reason, exit_code)
		microphone_volume = tonumber(stdout:match(REGEX_VOLUME))

		if microphone_volume ~= nil then
			microphone_slider.value = microphone_volume
		end
	end)
end

local function set_brightness_slider(brightness_slider)
	awful.spawn.easy_async_with_shell(BRIGHGTNESS_APP .. " g", function(stdout, stderr, reason, exit_code)
		if tonumber(stdout) then
			brightness_slider.value = tonumber(stdout)
		end
	end)
end

local control_panel_button = wibox.widget({
	{
		id = "icon",
		widget = wibox.widget.imagebox,
		image = beautiful.icon_control_panel,
		align = "center",
		valign = "center",
	},
	widget = wibox.container.margin,
	margins = 4,
})

-- Sound container
local volume_slider = create_slider()
volume_slider:connect_signal("property::value", function()
	local volume = volume_slider.value
	run_shell(SOUND_APP .. " set Master " .. volume .. "%")
end)
set_volume_slider(volume_slider)

local microphone_volume_slider = create_slider()
microphone_volume_slider:connect_signal("property::value", function()
	local volume = microphone_volume_slider.value
	run_shell(SOUND_APP .. " set Capture " .. volume .. "%")
end)
set_microphone_slider(microphone_volume_slider)

local volume_container = create_slider_container("Sound", {button_icon_name=beautiful.icon_volume, button_cmd=SOUND_CONTROL_APP .. " -t 3", slider=volume_slider}, {button_icon_name=beautiful.icon_microphone, button_cmd=SOUND_CONTROL_APP .. " -t 4", slider=microphone_volume_slider})
-- Sound container end

-- Brightness container
local brightness_slider = create_slider()
brightness_slider:connect_signal("property::value", function()
	local brightness = brightness_slider.value
	run_shell(BRIGHGTNESS_APP .. " s " .. brightness .. "%")
end)
set_brightness_slider(brightness_slider)

local brightness_container = create_slider_container("Brightness", {button_icon_name=beautiful.icon_brightness, button_cmd="", slider=brightness_slider})
-- Brightness container end

local button_network = create_button(beautiful.icon_network, NETWORK_APP)
local button_bluetooth = create_button(beautiful.icon_bluetooth, BLUETOOTH_APP)
local button_poweroff = create_button_with_color(beautiful.icon_power, "systemctl poweroff", "#c40029", "#c4abb0", "#f5cad3")
local button_lock = create_button_with_color(beautiful.icon_lock, "physlock -s", "#af8400", "#af9444", "#afa78f")
local upper_button_container =
	create_upper_button_container(button_network, button_bluetooth, button_poweroff, button_lock)

local settings_popup = awful.popup({
	screen = s,
	widget = wibox.container.background,
	placement = function(c)
		awful.placement.top_right(c, { margins = { top = dpi(43), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	bg = beautiful.base00,
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
				top = beautiful.container_margin,
				bottom = beautiful.container_margin,
				right = beautiful.container_margin,
				left = beautiful.container_margin,
			},
			layout = wibox.layout.flex.horizontal,
		},
		{
			volume_container,
			widget = wibox.container.margin,
			top = beautiful.container_margin,
			bottom = beautiful.container_margin,
			right = beautiful.container_margin,
			left = beautiful.container_margin,
		},
		{
			brightness_container,
			widget = wibox.container.margin,
			top = beautiful.container_margin,
			bottom = beautiful.container_margin,
			right = beautiful.container_margin,
			left = beautiful.container_margin,
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
		set_volume_slider(volume_slider)
		set_microphone_slider(microphone_volume_slider)
		set_brightness_slider(brightness_slider)
		toggle_popup()
	end
end)

return control_panel_button

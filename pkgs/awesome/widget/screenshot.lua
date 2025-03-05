local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")

local screenshot_button = wibox.widget({
	{
		id = "icon",
		widget = wibox.widget.imagebox,
		image = beautiful.dir .. "/icons/wibar/screenshot.svg",
		align = "center",
		valign = "center",
	},
	widget = wibox.container.margin,
	margins = 4,
})

screenshot_button:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.easy_async("flameshot gui", function(stdout, stderr, reason, exit_code)
		end)
	end
end)

return screenshot_button

local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local battery_path = "/sys/class/power_supply/BAT0/"
local battery_status_file = "status"
local battery_capacity_file = "capacity"

function file_exists(file)
    local file_handler = io.open(file)
    if file_handler then file_handler:close() end
    return file_handler and true or false
end

if file_exists(battery_path .. battery_status_file) == false then
    return wibox.widget { }
end

local battery_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
        image = beautiful.dir .. "/icons/wibar/battery.svg",
        align = "center",
        valign = "center",
    },
    widget = wibox.container.margin,
    margins = 4,
}

function is_charging()
    file_handler = io.open(battery_path .. battery_status_file, "r")
    battery_status = file_handler:read("*a"):gsub("\n", "")

    if battery_status == "Charging" then
        return true
    else
        return false
    end
end

function get_capacity_value()
    file_handler = io.open(battery_path .. battery_capacity_file, "r")
    battery_capacity = file_handler:read("*a"):gsub("\n", "")

    return tonumber(battery_capacity)
end

local test = gears.timer({timeout = 5, call_now = true, autostart = true, callback = 
function()
    battery_capacity = get_capacity_value()
    if is_charging() then
        if battery_capacity <= 20 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_20.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_30.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_50.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_60.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_80.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_90.svg"
        else
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/charging/battery_charging_100.svg"
        end
    else
        if battery_capacity <= 20 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_20.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_30.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_50.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_60.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_80.svg"
        elseif battery_capacity <= 30 then
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_90.svg"
        else
            battery_widget.icon.image = beautiful.dir .. "/icons/wibar/battery/battery_100.svg"
        end
    end
end})

return battery_widget

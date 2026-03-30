local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

theme = {}

-- Gather stylix colour scheme
file_handler = io.open("/etc/static/stylix/generated.json", "r")
stylix_theme = file_handler:read("*a")

theme.base00 = "#" .. stylix_theme:match('"base00":%s*"([%x]+)"')
theme.base01 = "#" .. stylix_theme:match('"base01":%s*"([%x]+)"')
theme.base02 = "#" .. stylix_theme:match('"base02":%s*"([%x]+)"')
theme.base03 = "#" .. stylix_theme:match('"base03":%s*"([%x]+)"')
theme.base04 = "#" .. stylix_theme:match('"base04":%s*"([%x]+)"')
theme.base05 = "#" .. stylix_theme:match('"base05":%s*"([%x]+)"')
theme.base06 = "#" .. stylix_theme:match('"base06":%s*"([%x]+)"')
theme.base07 = "#" .. stylix_theme:match('"base07":%s*"([%x]+)"')
theme.base08 = "#" .. stylix_theme:match('"base08":%s*"([%x]+)"')
theme.base09 = "#" .. stylix_theme:match('"base09":%s*"([%x]+)"')
theme.base0A = "#" .. stylix_theme:match('"base0A":%s*"([%x]+)"')
theme.base0B = "#" .. stylix_theme:match('"base0B":%s*"([%x]+)"')
theme.base0C = "#" .. stylix_theme:match('"base0C":%s*"([%x]+)"')
theme.base0D = "#" .. stylix_theme:match('"base0D":%s*"([%x]+)"')
theme.base0E = "#" .. stylix_theme:match('"base0E":%s*"([%x]+)"')
theme.base0F = "#" .. stylix_theme:match('"base0F":%s*"([%x]+)"')

theme.dir = os.getenv("HOME") .. "/.config/awesome/themes"

theme.wallpaper = theme.dir .. "/wallpaper.jpg"

theme.background = "#000000" .. "66"
theme.transparent = "#00000000"
theme.font = "Inter Bold 10"
theme.font_2 = "Ubuntu Nerd Font bold 11"

theme.bg_normal = theme.background
theme.bg_focus = "#121212"
theme.bg_urgent = theme.transparent
theme.bg_systray = theme.transparent

theme.fg_normal = "#ffffffde"
theme.fg_focus = "#e4e4e4"
theme.fg_urgent = "#CC9393"

theme.useless_gap = dpi(7)
theme.border_width = dpi(2)
theme.border_normal = theme.transparent
theme.border_focus = theme.base05

theme.titlebar_bg_focus = "#292929"
theme.taglist_fg_focus = theme.base01
theme.taglist_bg_focus = theme.transparent

theme.menu_height = dpi(16)
theme.menu_width = dpi(130)

theme.container_margin = dpi(11)

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = false

theme.menu_submenu_icon = theme.dir .. "/icons/menu/submenu.png"
theme.awesome_icon = theme.dir .. "/icons/awesome.svg"

theme.icon_applications_folder = "/icons/applications/"
theme.icon_peazip = theme.dir .. theme.icon_applications_folder .. "peazip.svg"
theme.icon_firefox = theme.dir .. theme.icon_applications_folder .. "firefox.svg"
theme.icon_vscode = theme.dir .. theme.icon_applications_folder .. "vscode.svg"
theme.icon_imhex = theme.dir .. theme.icon_applications_folder .. "imhex.svg"
theme.icon_terminal = theme.dir .. theme.icon_applications_folder .. "utilities-terminal.svg"
theme.icon_nautilus = theme.dir .. theme.icon_applications_folder .. "files.svg"
theme.icon_exegol = theme.dir .. theme.icon_applications_folder .. "exegol.png"
theme.icon_lock = theme.dir .. theme.icon_applications_folder .. "lock.svg"
theme.icon_power = theme.dir .. theme.icon_applications_folder .. "power_off.svg"
theme.icon_exit = theme.dir .. theme.icon_applications_folder .. "exit.svg"
theme.icon_restart = theme.dir .. theme.icon_applications_folder .. "autorenew.svg"
theme.icon_keyboard = theme.dir .. theme.icon_applications_folder .. "keyboard.svg"
theme.icon_menu = theme.dir .. theme.icon_applications_folder .. "menu.svg"
theme.icon_window_manager = theme.dir .. theme.icon_applications_folder .. "window_manager.svg"
theme.icon_bluetooth = theme.dir .. "/icons/wibar/control_panel/bluetooth.svg"

-- Wibar
theme.layout_tile = theme.dir .. "/icons/wibar/tile.svg"
theme.layout_floating = theme.dir .. "/icons/wibar/floating.svg"
theme.icon_screenshot = theme.dir .. "/icons/wibar/screenshot.svg"

-- Wibar - Control panel
theme.icon_bluetooth = theme.dir .. "/icons/wibar/control_panel/bluetooth.svg"
theme.icon_network = theme.dir .. "/icons/wibar/control_panel/network.svg"
theme.icon_control_panel = theme.dir .. "/icons/wibar/control_panel/control_panel.svg"
theme.icon_volume = theme.dir .. "/icons/wibar/control_panel/volume.svg"
theme.icon_microphone = theme.dir .. "/icons/wibar/control_panel/microphone.svg"
theme.icon_brightness = theme.dir .. "/icons/wibar/control_panel/brightness.svg"

-- Wibar - Battery
theme.icon_battery_folder = "/icons/wibar/battery/"

theme.icon_battery_charging_20 = theme.icon_battery_folder .. "charging/battery_charging_20.svg"
theme.icon_battery_charging_30 = theme.icon_battery_folder .. "charging/battery_charging_30.svg"
theme.icon_battery_charging_50 = theme.icon_battery_folder .. "charging/battery_charging_50.svg"
theme.icon_battery_charging_60 = theme.icon_battery_folder .. "charging/battery_charging_60.svg"
theme.icon_battery_charging_80 = theme.icon_battery_folder .. "charging/battery_charging_80.svg"
theme.icon_battery_charging_90 = theme.icon_battery_folder .. "charging/battery_charging_90.svg"
theme.icon_battery_charging_100 = theme.icon_battery_folder .. "charging/battery_charging_100.svg"

theme.icon_battery_20 = theme.icon_battery_folder .. "battery_20.svg"
theme.icon_battery_30 = theme.icon_battery_folder .. "battery_30.svg"
theme.icon_battery_50 = theme.icon_battery_folder .. "battery_50.svg"
theme.icon_battery_60 = theme.icon_battery_folder .. "battery_60.svg"
theme.icon_battery_80 = theme.icon_battery_folder .. "battery_80.svg"
theme.icon_battery_90 = theme.icon_battery_folder .. "battery_90.svg"
theme.icon_battery_100 = theme.icon_battery_folder .. "battery_100.svg"

theme.notification_bg = theme.transparent
theme.notification_shape = function(cr, height, width)
	gears.shape.rounded_rect(cr, height, width, 6)
end

function theme.at_screen_connect(s)
	-- If wallpaper is a function, call it with the screen
	local wallpaper = theme.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)
end

return theme

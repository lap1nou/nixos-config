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

theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/1"

theme.wallpaper = theme.dir .. "/wallpaper.jpg"

theme.background = "#000000" .. "66"
theme.transparent = "#00000000"
theme.system_white_dark = "#E5E5E5"
theme.system_white_light = "#F8F8F2"
theme.system_blue_dark = "#6498EF"
theme.accent = theme.system_blue_dark
theme.font = "Inter Bold 10"

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
theme.border_focus = "#597bab"

theme.titlebar_bg_focus = "#292929"
theme.taglist_fg_focus = theme.base01
theme.taglist_bg_focus = theme.transparent

theme.menu_height = dpi(16)
theme.menu_width = dpi(130)

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = false

theme.menu_submenu_icon = theme.dir .. "/icons/menu/submenu.png"
theme.awesome_icon = theme.dir .. "/icons/awesome.svg"

theme.layout_tile = theme.dir .. "/icons/wibar/tile.svg"
theme.layout_floating = theme.dir .. "/icons/wibar/floating.svg"

theme.icon_peazip = theme.dir .. "/icons/applications/peazip.svg"
theme.icon_firefox = theme.dir .. "/icons/applications/firefox.svg"
theme.icon_vscode = theme.dir .. "/icons/applications/vscode.svg"
theme.icon_imhex = theme.dir .. "/icons/applications/imhex.svg"
theme.icon_terminal = theme.dir .. "/icons/applications/utilities-terminal.svg"
theme.icon_nautilus = theme.dir .. "/icons/applications/files.svg"
theme.icon_exegol = theme.dir .. "/icons/applications/exegol.png"
theme.icon_lock = theme.dir .. "/icons/applications/lock.svg"
theme.icon_power = theme.dir .. "/icons/applications/power_off.svg"

theme.notification_bg = theme.transparent
theme.notification_shape = function (cr, height, width)
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

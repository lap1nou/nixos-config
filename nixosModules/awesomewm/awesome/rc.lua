-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup.widget")
local utils = require("utils")

-- Software name definition
local FILE_EXPLORER = "nemo" 
local TERMINAL = "kitty" 
local EDITOR = "code"
local ZIPPING = "peazip"
local BROWSER = "firefox"
local HEX_EDITOR = "imhex"
local SCREENLOCK = "physlock"
local SHUTDOWN = "systemctl poweroff"

-- Add terminal hotkeys to the AwesomeWM cheatsheet
for group_name, group_data in pairs({
	[firstToUpper(TERMINAL)] = { color = "#009F00" },
}) do
	hotkeys_popup.add_group_rules(group_name, group_data)
end

local terminal_keys = {
	[firstToUpper(TERMINAL) .. ": general"] = {
		{
			modifiers = { "Ctrl" },
			keys = {
				c = "copy the selected text",
				v = "paste the selected text",
			},
		},
		{
			modifiers = { "Ctrl", "Shift" },
			keys = {
				page_up = "scroll up",
				page_down = "scroll down",
				home = "scroll to start",
				["end"] = "scroll to end",
			},
		},
	},
	[firstToUpper(TERMINAL) .. ": tabs"] = {
		{
			modifiers = { "Ctrl", "Shift" },
			keys = {
				t = "new tab",
				q = "close tab",
			},
		},
	},
	[firstToUpper(TERMINAL) .. ": muliplexing"] = {
		{
			modifiers = { "Ctrl", "Shift" },
			keys = {
				enter = "new window",
				w = "close window",
			},
		},
	},
}
hotkeys_popup.add_hotkeys(terminal_keys)

-- Check for errors
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

beautiful.init("~/.config/awesome/themes/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile, -- https://www.reddit.com/r/awesomewm/comments/j3jtrn/set_awesome_wm_to_tiling_by_default/
	awful.layout.suit.floating,
}

-- Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
		beautiful.icon_keyboard
	},
	{ "Restart", awesome.restart, beautiful.icon_restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
		beautiful.icon_exit
	},
}

mymainmenu = awful.menu({
	items = {
		{ "Awesome", myawesomemenu, beautiful.icon_window_manager },
		{
			firstToUpper(FILE_EXPLORER),
			function()
				awful.spawn.with_shell(FILE_EXPLORER)
			end,
			beautiful.icon_nautilus,
		},
		{
			firstToUpper(ZIPPING),
			function()
				awful.spawn.with_shell(ZIPPING)
			end,
			beautiful.icon_peazip,
		},
		{
			firstToUpper(BROWSER),
			function()
				awful.spawn.with_shell(BROWSER)
			end,
			beautiful.icon_firefox,
		},
		{
			"VSCode",
			function()
				awful.spawn.with_shell(EDITOR)
			end,
			beautiful.icon_vscode,
		},
		{
			firstToUpper(HEX_EDITOR),
			function()
				awful.spawn.with_shell(HEX_EDITOR)
			end,
			beautiful.icon_imhex,
		},
		{ "Open terminal", TERMINAL, beautiful.icon_terminal },
		{
			"Lock screen",
			function()
				awful.spawn(SCREENLOCK .. " -s")
			end,
			beautiful.icon_lock,
		},
		{
			"Shutdown",
			function()
				awful.spawn.with_shell(SHUTDOWN)
			end,
			beautiful.icon_power,
		},
	},
	theme = {
		width = 250,
		height = 30,
		bg_normal = beautiful.base00,
		bg_focus = beautiful.base01,
		border_width = 5,
		border_color = beautiful.base00,
		font = beautiful.font_2
	}
})

mylauncher = awful.widget.launcher({ image = beautiful.icon_menu, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = TERMINAL

-- Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local control_panel = require("widget.control_panel")
local screenshot_button = require("widget.screenshot")
local battery = require("widget.battery")

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1]) -- https://fontawesome.com/icons/circle?f=classic&s=solid

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = 30 })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			s.mytaglist
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			screenshot_button,
			control_panel,
			battery,
			mytextclock,
			s.mylayoutbox,
		},
	})
end)

-- Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev),
	awful.button({}, 8, awful.tag.viewnext)
))

-- Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey }, "h", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({}, "Print", function()
		awful.util.spawn("flameshot gui", false)
	end, { description = "take a screenshot", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	-- Standard program
	awful.key({ modkey }, "q", function()
		awful.spawn(TERMINAL)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	-- Menubar
	awful.key({ modkey }, "r", function()
		awful.spawn.with_shell("vicinae toggle")
	end, { description = "run Vicinae", group = "launcher" }),
	awful.key({ modkey }, "e", function()
		awful.spawn.with_shell("vicinae vicinae://extensions/lap1nou/exegol/exegol")
	end, { description = "run Vicinae Exegol extension", group = "launcher" })
)

clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey,}, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end),
	awful.button({}, 8, function(t)
		awful.tag.viewnext(t.screen)
	end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

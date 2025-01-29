local wezterm = require 'wezterm'
local mux = wezterm.mux
-- local gnome_cursor_fix = require 'gnome_cursor_fix' -- https://github.com/wez/wezterm/issues/1742#issuecomment-1075333507 & https://github.com/belak/dotfiles/blob/e1f6a4faa45737e4adb1d57ec04b98d677fc7be9/config/wezterm/wayland_gnome.lua#L24
local config = {}

-- gnome_cursor_fix.apply_to_config(config)

-- https://github.com/mbadolato/iTerm2-Color-Schemes
-- config.color_scheme = 'Tomorrow Night'
-- config.color_scheme = 'Breeze'
config.color_scheme = 'Brogrammer'
config.enable_scroll_bar = true
config.hide_mouse_cursor_when_typing = false

-- Source: https://github.com/wez/wezterm/issues/5990
--config.front_end = "WebGpu"
--config.webgpu_power_preference = "HighPerformance"

config.launch_menu = {
    {
      -- Optional label to show in the launcher. If omitted, a label
      -- is derived from the `args`
      label = "Exegol start",
      args = {"wezterm", "cli", "spawn", "--", "run_command_in_panes"},
  
      -- You can specify an alternative current working directory;
      -- if you don't specify one then a default based on the OSC 7
      -- escape sequence will be used (see the Shell Integration
      -- docs), falling back to the home directory.
      -- cwd = "/some/path"
  
      -- You can override environment variables just for this command
      -- by setting this here.  It has the same semantics as the main
      -- set_environment_variables configuration option described above
      -- set_environment_variables = { FOO = "bar" },
    },
  }

config.keys = { -- https://wezfurlong.org/wezterm/config/keys.html#available-actions
    { -- CTRL+f -> Search, to exit the search push 'Esc'
        key = 'f',
        mods = 'CTRL',
        action = wezterm.action.Search { CaseInSensitiveString = '' },
    },
    { -- CTRL+SHIFT+RightArrow -> Split horizontal
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitHorizontal {
          args = { 'zsh' },
        },
    },
    { -- CTRL+SHIFT+DownArrow -> Split vertical
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitVertical {
          args = { 'zsh' },
        },
    },
    { -- CTRL+w -> Close current pane
        key = 'w',
        mods = 'CTRL',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- Tabs
-- config.use_fancy_tab_bar = true
-- config.show_tab_index_in_tab_bar = false
-- config.integrated_title_button_style = "Gnome"
-- config.integrated_title_button_color = "white"
config.window_decorations = "NONE"
-- enable_tab_bar = false

wezterm.on('format-tab-title', function(tab)
    local pane = tab.active_pane
    local title = pane.title

    if pane.domain_name then
        title = title .. ' - ' .. wezterm.hostname()
    end

    return title
end)

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})

    pane:split { direction = 'Bottom', size = 0.5, top_level = true }
    pane:split { direction = 'Right', size = 0.5 }
end)

return config

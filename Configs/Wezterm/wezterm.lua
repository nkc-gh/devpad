-- In Linux Create the config at ```~/.wezterm.lua```

--[[
Prerequisite Downloads

1. Wezterm
2. Fish or Zsh or Bash
3. Ubuntu Fonts
]]


local wezterm = require 'wezterm' -- fetches the pre-built module (table of functions) wezterm provides

local config = {} -- creates a table in which i can assign values

config.default_prog = { '/usr/bin/fish' } -- WezTerm's actual field name for "program to run on start" — not "shell", since it accepts any program

config.font = wezterm.font('Ubuntu Mono', { weight = 'Medium' }) -- wezterm.font() passses these values to its internal tool and fills with other values and hand over to config.font

config.font_size = 12.0 -- WezTerm-specific: unit is POINTS, not pixels — stays physically consistent across different screen DPIs

config.line_height = 1.2 -- WezTerm-specific field; not a general Lua/config concept

config.front_end = 'WebGpu' -- WezTerm-specific field; only 3 valid values: WebGpu, OpenGL, Software

config.colors = {
  background = '#000000', -- applies background color of black
  foreground = '#ffffff' -- applies foreground color of all output
}

config.default_cursor_style = 'SteadyBar' -- applies SteadyBar means | instead of block cursor style

config.enable_tab_bar = false -- disables tab bar

config.scrollback_lines = 2000 -- scrollback limits to 2000 lines

-- open at maximized

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config -- hands the finished config table back to wezterm, which reads it to apply all your settings
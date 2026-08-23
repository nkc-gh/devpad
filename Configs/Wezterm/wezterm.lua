local wezterm = require 'wezterm' -- fetches the pre-built module (table of functions) wezterm provides

local config = wezterm.config_builder() -- WezTerm-specific function; returns a defaults table WITH validation (vs old style: local config = {}, which silently ignores typos)

config.default_prog = { '/usr/bin/zsh' } -- WezTerm's actual field name for "program to run on start" — not "shell", since it accepts any program

config.font = wezterm.font('Ubuntu Mono', { weight = 'Medium' }) -- wezterm.font() is a WezTerm function; 2nd arg's accepted keys (weight, stretch, style) are documented per-function at wezterm.org, not guessable from Lua alone

config.font_size = 12.0 -- WezTerm-specific: unit is POINTS, not pixels — stays physically consistent across different screen DPIs

config.line_height = 1.2 -- WezTerm-specific field; not a general Lua/config concept

config.front_end = 'WebGpu' -- WezTerm-specific field; only 3 valid values: WebGpu (default), OpenGL, Software

config.colors = {
  background = '#000000', -- applies background color of black
  foreground = '#ffffff' -- applies foreground color of all output
}

config.default_cursor_style = 'SteadyBar' -- applies SteadyBar means | instead of block cursor style

return config -- hands the finished config table back to wezterm, which reads it to apply all your settings
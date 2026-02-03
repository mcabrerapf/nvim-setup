local wezterm = require 'wezterm'

local config = wezterm.config_builder()
-- NOTE: To get all installed fonts run: wezterm ls-fonts --list-system
-- "FiraCode Nerd Font Mono" "JetBrains Mono" "Terminess Nerd Font Mono"
config.font = wezterm.font('FiraCode Nerd Font Mono', {})
config.cursor_blink_rate = 400
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
-- config.initial_cols = 120
-- config.initial_rows = 28
-- config.font_size = 10
-- config.color_scheme = 'AdventureTime'
config.window_background_opacity = 0.95
config.colors = {
  -- background = "pink",
  -- split = "pink",
}
config.keys = {
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '+',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '>',
    mods = 'CTRL|SHIFT ',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '<',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
}
-- config.mouse_bindings = {
-- 	-- and make CTRL-Click open hyperlinks
-- 	{
-- 		event = { Up = { streak = 1, button = "Left" } },
-- 		mods = "CTRL",
-- 		action = act.OpenLinkAtMouseCursor,
-- 	},
-- 	-- NOTE that binding only the 'Up' event can give unexpected behaviors.
-- 	-- Read more below on the gotcha of binding an 'Up' event only.
-- }
return config

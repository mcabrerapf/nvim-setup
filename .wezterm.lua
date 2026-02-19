-- On windows place this file in ~/.config/wezterm/
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- local font_to_use = "0xProto Nerd Font Mono"
-- local font_to_use = "BlexMono Nerd Font Mono"
-- local font_to_use = "DepartureMono Nerd Font Mono"
-- local font_to_use = "FiraCode Nerd Font Mono"
-- local font_to_use = "GeistMono Nerd Font Mono"
-- local font_to_use = "Iosevka Nerd Font Mono"
-- local font_to_use = "JetBrainsMono Nerd Font Mono"
-- local font_to_use = "Lilex Nerd Font Mono"
-- local font_to_use = "Monoid Nerd Font Mono"
-- local font_to_use = "VictorMono Nerd Font Mono" -- Pretty cool, cursive for italics
-- local font_to_use = "ZedMono Nerd Font Mono"
-- {} [] -> << >> <= >= == === != !== function var local function const
-- NOTE: To get all installed fonts run: wezterm ls-fonts --list-system
--
-- config.font = wezterm.font(font_to_use)
config.cursor_blink_rate = 400
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 9
config.line_height = 1.2
config.window_background_opacity = 0.90
-- config.color_scheme = 'AdventureTime'
config.colors = {
  -- cursor_bg = "red",
  -- cursor_border = "red"
  -- background = "pink",
  -- split = "pink",
}
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.keys = {
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "+",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = ">",
    mods = "CTRL|SHIFT ",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "<",
    mods = "CTRL",
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
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)
return config

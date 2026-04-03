local wezterm = require("wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local config = wezterm.config_builder()
local pane_actions = require("actions_pane")

config.keys = {
  --redirect shift tab in neovim to F13 so can use next and prev buffer keymap with
  --tab and tab shift. Tab-Shift maps to ctrl+i in terminal
  {
    key = "i",
    mods = "CTRL",
    action = wezterm.action.SendKey({ key = "F13" }),
  },
  --ctrl & other key binds: enter, shift, space
  {
    key = "Enter",
    mods = "CTRL",
    action = wezterm.action.SendKey({ key = "Enter", mods = "CTRL" }),
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendKey({ key = "Enter", mods = "SHIFT" }),
  },
  {
    key = " ",
    mods = "CTRL",
    action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }),
  },
  --move pane to workspace
  {
    key = "m",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(pane_actions.move_tab_to_workspace),
  },
  --move pane to tab
  {
    key = "y",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(pane_actions.move_pane_to_tab),
  },
}

-- config.color_scheme = "nightfox"
-- config.color_scheme = "Nord (Gogh)"
-- config.color_scheme = "Ashes (base16)"
-- config.color_scheme = 'Ashes (dark) (terminal.sexy)'
-- config.color_scheme = "Ayu Mirage" --like nord but slightly better contrast
-- config.color_scheme = "Azu (Gogh)"
-- config.color_scheme = "Black Metal (Gorgoroth) (base16)"
-- config.color_scheme = "Brush Trees Dark (base16)"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Dracula (base16)"
-- config.color_scheme = "Eva (base16)"
-- config.color_scheme = "FarSide (terminal.sexy)"
-- config.color_scheme = "Frontend Galaxy (Gogh)"
-- config.color_scheme = "Gooey (Gogh)"
-- config.color_scheme = "Harmonic16 Dark (base16)"
-- config.color_scheme = "Horizon Dark (base16)"
-- config.color_scheme = "Tinacious Design (Dark)"
config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Tokyo Night Moon"
-- config.color_scheme = "rose-pine"
-- config.color_scheme = "Rouge 2"

config.default_prog = { "pwsh.exe", "-NoLogo" }
config.animation_fps = 1
config.max_fps = 120
config.front_end = "OpenGL" -- or "OpenGL" "WebGpu"
-- config.use_ime = false
config.default_workspace = "main"
config.window_decorations = "NONE | RESIZE"
config.window_padding = { left = "1cell", right = "1cell", top = 0, bottom = 0 }

-- config.cursor_blink_rate = 500
-- config.default_cursor_style = "BlinkingBlock"

config.hide_mouse_cursor_when_typing = true
config.scrollback_lines = 10000

config.inactive_pane_hsb = {
  saturation = 0.9, -- Slightly reduce saturation for a muted effect
  brightness = 0.5, -- Dim brightness to half for a clear distinction
}

config.font = wezterm.font("JetBrains Mono", {
  weight = "Regular",
  stretch = "Normal",
  style = "Normal",
})
config.font_size = 10
config.freetype_load_flags = "NO_HINTING"
-- settings to tweak font rendering
-- config.freetype_load_target = "Normal" -- softer hinting
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"  -- subpixel AA (ClearType-style)
-- config.freetype_render_target = "VerticalLcd"
-- config.font_shaper = "Harfbuzz"
-- config.freetype_pnm_contrast = 0.8  -- Lower than 1.0 makes it "thinner"
-- config.freetype_pnm_gamma = 1.8      -- Higher values often make fonts look leaner
config.cell_width = 0.9 -- Try 0.9 or 0.95 to "thin" the appearance

-- prevent any opacity or background blurring, improves latency
config.win32_system_backdrop = "Disable"
config.window_background_opacity = 1.0

-- config.line_height = 1
-- config.allow_win32_input_mode = true -- helps on Windows for low-latency input

-- Try to load 'profile.lua'. If it exists, call its 'apply' function.
local has_profile, profile = pcall(require, "profile")
if has_profile and profile.apply then
  profile.apply(config)
end

bar.apply_to_config(config)

return config

local wezterm = require("wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local config = wezterm.config_builder()

config.keys = {
	--redirect shift tab in neovim to F13 so can use next and prev buffer keymap with
	--tab and tab shift. Tab-Shift maps to ctrl+i in terminal
	{
		key = "i",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "F13" }),
	},
	{
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "Enter", mods = "CTRL" }),
	},
	-- Ensure Shift+Enter works too
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
}
-- This is where you actually apply your config choices
config.window_decorations = "NONE | RESIZE"
-- For example, changing the color scheme:
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
config.max_fps = 200
config.default_workspace = "main"
config.window_padding = { left = "1cell", right = "1cell", top = 0, bottom = 0 }
--config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 11

-- config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
-- config.font_size = 11.25
-- config.freetype_load_target = "HorizontalLcd"
-- config.freetype_render_target = "HorizontalLcd"
-- config.font_size = 12
-- config.enable_tab_bar = false
-- and finally, return the configuration to wezterm
bar.apply_to_config(config)

return config

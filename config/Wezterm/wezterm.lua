local wezterm = require("wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local act = wezterm.action
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
	--move tab to another workspace
	{
		key = "m",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local workspaces = wezterm.mux.get_workspace_names()
			local choices = {}
			for _, name in ipairs(workspaces) do
				table.insert(choices, { label = name })
			end

			win:perform_action(
				wezterm.action.InputSelector({
					title = "Move pane to workspace...",
					choices = choices,
					action = wezterm.action_callback(function(inner_win, inner_pane, id, label)
						if not label then
							return
						end

						local mux_pane = wezterm.mux.get_pane(inner_pane:pane_id())

						-- 1. Find the existing window for that workspace
						local target_window = nil
						for _, w in ipairs(wezterm.mux.all_windows()) do
							if w:get_workspace() == label then
								target_window = w
								break
							end
						end

						if target_window then
							-- 2. Create a new tab in the target window
							local new_tab, _, _ = target_window:spawn_tab({})
							-- 3. Move our current pane into that new tab
							mux_pane:move_to_new_window(label) -- This creates the new window
							-- Note: Because API methods vary by version, if the above still
							-- creates a duplicate window, the most reliable way in older
							-- versions is actually to use the CLI from within Lua:

							local pane_id = inner_pane:pane_id()
							local window_id = target_window:window_id()

							wezterm.run_child_process({
								"wezterm",
								"cli",
								"move-pane-to-new-tab",
								"--pane-id",
								tostring(pane_id),
								"--window-id",
								tostring(window_id),
							})
						else
							-- Workspace doesn't exist yet, safe to just move
							mux_pane:move_to_new_window(label)
						end

						wezterm.mux.set_active_workspace(label)
					end),
				}),
				pane
			)
		end),
	},
	--move pane to tab
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local mux_win = win:mux_window()
			local tabs = mux_win:tabs()
			local choices = {}

			for _, tab in ipairs(tabs) do
				local title = tab:get_title()
				local tab_id = tab:tab_id()
				if title == "" or title == nil then
					title = "Tab ID: " .. tab_id
				end
				table.insert(choices, { id = tostring(tab_id), label = title })
			end

			win:perform_action(
				wezterm.action.InputSelector({
					title = "Move current pane to tab...",
					choices = choices,
					action = wezterm.action_callback(function(inner_win, inner_pane, id, label)
						if not id then
							return
						end

						-- Find the target tab object based on the ID selected
						local target_tab = nil
						for _, t in ipairs(tabs) do
							if tostring(t:tab_id()) == id then
								target_tab = t
								break
							end
						end

						if target_tab then
							-- Get all panes in that tab and find the one with the lowest ID
							local panes = target_tab:panes()
							local lowest_pane_id = panes[1]:pane_id()
							for i = 2, #panes do
								if panes[i]:pane_id() < lowest_pane_id then
									lowest_pane_id = panes[i]:pane_id()
								end
							end

							-- Execute the move
							wezterm.run_child_process({
								"wezterm",
								"cli",
								"split-pane",
								"--pane-id",
								tostring(lowest_pane_id),
								"--move-pane-id",
								tostring(inner_pane:pane_id()),
								"--horizontal", -- You can change this to --top, --bottom, etc.
							})
						end
					end),
				}),
				pane
			)
		end),
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
config.animation_fps = 1
config.max_fps = 120
config.front_end = "WebGpu" -- or "OpenGL" "WebGpu"
-- config.use_ime = false
config.default_workspace = "main"
config.window_padding = { left = "1cell", right = "1cell", top = 0, bottom = 0 }
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("JetBrains Mono")

-- config.font = wezterm.font_with_fallback({
-- 	{
-- 		family = "JetBrains Mono",
-- 		weight = "Regular",
-- 		stretch = "Normal",
-- 		style = "Normal",
-- 	},
-- 	"Symbols Nerd Font Mono", -- for devicons/nerd symbols
-- 	"Noto Color Emoji", -- for emoji
-- })

-- config.freetype_render_target = "Normal"

-- config.cursor_blink_rate = 500
-- config.default_cursor_style = "BlinkingBlock"
config.hide_mouse_cursor_when_typing = true
config.scrollback_lines = 10000

config.inactive_pane_hsb = {
	saturation = 0.9, -- Slightly reduce saturation for a muted effect
	brightness = 0.5, -- Dim brightness to half for a clear distinction
}

-- config.freetype_load_target = "Normal"
-- config.freetype_render_target = "Normal"

-- config.freetype_load_target = "HorizontalLcd"
-- config.freetype_render_target = "HorizontalLcd"
--unix_domains
-- config.unix_domains = {
-- 	{
-- 		name = "unix",
-- 		-- On Windows, this automatically uses a Named Pipe
-- 	},
-- }
--
-- -- This ensures that when you click the WezTerm icon,
-- -- it connects to the background server immediately.
-- config.default_gui_startup_args = { "connect", "unix" }

-- To this (or just delete them, as 'local' is the default):

-- config.default_prog = { "pwsh.exe", "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass" }

-- -- below screws up the font
-- config.default_prog = { "cmd.exe" }
-- config.default_prog = {
-- 	"pwsh.exe",
-- 	"-NoLogo",
-- 	"-NoProfile",
-- 	"-ExecutionPolicy",
-- 	"Bypass",
-- 	"-NoExit",
-- 	"-Command",
-- 	". 'C:\\Users\\ian.gibson\\pwsh-profile.ps1'", -- Double backslashes for Lua
-- }
-- config.enable_shell_integration = false

-- config.font = wezterm.font("FiraCode Nerd Font")

-- JetBrains Mono
-- config.font_size = 11
-- config.freetype_render_target = "HorizontalLcd"
-- config.freetype_load_target = "Normal" -- softer hinting
-- config.freetype_render_target = "HorizontalLcd"  -- subpixel AA (ClearType-style)
config.font = wezterm.font("JetBrains Mono", {
	weight = "Regular",
	stretch = "Normal",
	style = "Normal",
})
-- config.font = wezterm.font("JetBrains Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 10
config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Normal"
-- config.custom_block_glyphs = true
-- config.freetype_load_target = "Light"
-- config.freetype_load_target = "HorizontalLcd"
-- config.freetype_render_target = "HorizontalLcd"
-- config.freetype_render_target = "VerticalLcd"
-- config.freetype_render_target = "HorizontalLcdBGR"
-- config.font_shaper = "Harfbuzz"
-- config.freetype_pnm_contrast = 0.8  -- Lower than 1.0 makes it "thinner"
-- config.freetype_pnm_gamma = 1.8      -- Higher values often make fonts look leaner
config.cell_width = 0.9 -- Try 0.9 or 0.95 to "thin" the appearance
-- config.line_height = 1
--perf test
-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"
-- config.max_fps = 120
-- config.animation_fps = 1           -- reduces tab/animation overhead
-- -- Fonts/ligatures can be surprisingly expensive
-- -- If you use a ligature font, try disabling ligatures:
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
--   -- Input path
-- config.allow_win32_input_mode = true -- helps on Windows for low-latency input
--   -- Misc
-- config.enable_tab_bar = false        -- try off; the tab bar animates/redraws
-- config.term = "xterm-256color"

-- config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
-- config.font_size = 11.25
-- config.freetype_load_target = "HorizontalLcd"
-- config.freetype_render_target = "HorizontalLcd"
-- config.font_size = 12
-- config.enable_tab_bar = false
-- and finally, return the configuration to wezterm

bar.apply_to_config(config)

wezterm.on("gui-startup", function()
	local mux = wezterm.mux

	-- ==========================================================
	-- WORKSPACE 1: Core Libraries
	-- ==========================================================
	local tab1_core, pane1_core, win_core = mux.spawn_window({
		workspace = "Core Libs",
		cwd = "c:/dev/main/Components/CoreLibraries/",
		args = { "nvim", "c:/dev/main/Components/CoreLibraries/DebugIan/Program.cs" },
	})
	tab1_core:set_title("nvim")

	local tab2_core, pane2_core = win_core:spawn_tab({
		cwd = "c:/dev/main/Components/CoreLibraries/DebugIan/bin/Debug/net6.0/",
	})
	tab2_core:set_title("Shell")

	local tab3_core, pane3_core = win_core:spawn_tab({
		cwd = "~",
		args = { "yazi" },
	})
	tab3_core:set_title("Files")
	--
	tab1_core:activate()

	-- ==========================================================
	-- WORKSPACE 2: MVC
	-- ==========================================================
	local dir_path = [[C:\dev\main\Web\NexusTradeEntryMVC]]
	local tab1_mvc, pane1_mvc, win_mvc = mux.spawn_window({
		workspace = "MVC",
		cwd = dir_path,
		args = { "nvim", "-c", "cd " .. dir_path },
	})
	tab1_mvc:set_title("Editor")

	local tab2_mvc, pane2_mvc = win_mvc:spawn_tab({
		cwd = "c:/dev/main/Web/NexusTradeEntryMVC/",
	})
	tab2_mvc:set_title("Shell")

	local tab3_mvc, pane3_mvc = win_mvc:spawn_tab({
		cwd = "~",
		args = { "yazi" },
	})
	tab3_mvc:set_title("Files")

	tab1_mvc:activate()

	-- ==========================================================
	-- WORKSPACE 3: Files
	-- ==========================================================
	local tab1_files, pane1_files, win_files = mux.spawn_window({
		workspace = "Files",
		cwd = "c:\\",
		args = { "yazi" },
	})
	tab1_files:set_title("Yazi")

	-- ==========================================================
	-- Finalize: Set the initial active workspace
	-- ==========================================================
	mux.set_active_workspace("Core Libs")
end)
-- wezterm.on("gui-startup", function()
-- 	local mux = wezterm.mux
--
-- 	local tab1, pane1, window = mux.spawn_window({
-- 		cwd = "c:/dev/main/Components/CoreLibraries/",
-- 		args = { "nvim", "c:/dev/main/Components/CoreLibraries/DebugIan/Program.cs" },
-- 	})
--
-- 	local split_shell_corelibs = pane1:split({
-- 		direction = "Right",
-- 		cwd = "c:/dev/main/Components/CoreLibraries/DebugIan/bin/Debug/net6.0/",
-- 	})
--
-- 	pane1:activate()
-- 	tab1:set_zoomed(pane1, true)
-- 	tab1:set_title("Core Libraries")
--
-- 	local dir_path = [[C:\dev\main\Web\NexusTradeEntryMVC]]
-- 	local dir_uri = "file:///c:/dev/main/Web/NexusTradeEntryMVC/"
--
-- 	local tab2, pane2 = window:spawn_tab({
-- 		cwd = dir_uri, -- gives the process the right cwd
-- 		args = { "nvim", "-c", "cd " .. dir_path }, -- force Neovim’s cwd after init
-- 	})
--
-- 	-- local tab2, pane2 = window:spawn_tab({
-- 	-- 	-- cwd = "c:/dev/main/Web/NexusTradeEntryMVC/",
-- 	-- 	cwd = "c:/dev/main/Web/NexusTradeEntryMVC/",
-- 	-- 	args = { "nvim" },
-- 	-- })
--
-- 	local split_shell_mvc = pane2:split({
-- 		direction = "Right",
-- 		cwd = "c:/dev/main/Web/NexusTradeEntryMVC/",
-- 	})
--
-- 	pane2:activate()
-- 	tab2:set_title("MVC")
-- 	tab2:set_zoomed(pane2, true)
--
-- 	local tab3, pane3 = window:spawn_tab({
-- 		cwd = "c:\\",
-- 		args = { "yazi" },
-- 	})
--
-- 	-- local shell_split_yazi = pane3:split({
-- 	-- 	direction = "Right",
-- 	-- 	cwd = "c:/",
-- 	-- })
--
-- 	tab3:set_title("Files")
--
-- 	wezterm.time.call_after(1, function()
-- 		tab1:activate()
-- 	end)
--
-- 	-- local gui_win = window:gui_window()
-- 	-- wezterm.time.call_after(0.5, function()
-- 	-- 	gui_win:perform_action(wezterm.action.TogglePaneZoomState, pane1)
-- 	-- 	pane1:write('echo "call_after triggered"\n')
-- 	-- 	gui_win:perform_action(wezterm.action.TogglePaneZoomState, pane2)
-- 	-- 	pane2:write('echo "call_after triggered"\n')
-- 	-- end)
-- end)

return config

local wezterm = require("wezterm")
local module = {}

function module.apply(config)
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
    -- WORKSPACE 2: Web
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

    mux.set_active_workspace("Core Libs")
  end)
end

return module

local wezterm = require("wezterm")
local M = {}

function M.move_tab_to_workspace(win, pane)
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
end

function M.move_pane_to_tab(win, pane)
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
end

return M

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from apps. You'll probably like this.
-- hl.window_rule({
--     name = "suppress-maximize-events",
--     match = { class = ".*" },
--     suppress_event = "maximize",
-- })

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name = "fix-xwayland-drags",
--     match = {
--         class = "^$",
--         title = "^$",
--         xwayland = true,
--         float = true,
--         fullscreen = false,
--         pin = false,
--     },
--     no_focus = true,
-- })

-- Workspaces 1-7 on the ultrawide, 8-10 on the vertical monitor
-- (outputs come from the `monitors` table in hyprland/monitors.lua)
for i = 1, 7 do
    hl.workspace_rule({ workspace = tostring(i), monitor = monitors.main.output })
end
for i = 8, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = monitors.vertical.output })
end

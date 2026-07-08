-- Single source of truth for the monitor setup.
-- When the hardware changes, edit this table and nothing else --
-- hl.monitor, workspace rules, and wayvnc all reference it.
--
-- Field reference: https://wiki.hypr.land/Configuring/Basics/Monitors/

monitors = {
    main = { -- ultrawide
        output    = "eDP-1",
        mode      = "1366x768@60.00Hz",
        position  = "0x0",
        scale     = 1,
        transform = 0,
        bitdepth  = 8,
        vrr       = 0,
    },

    vertical = { -- rotated side monitor
        output    = "HDMI-A-2",
        mode      = "1440x900@74.98Hz",
        position  = "3440x0",
        scale     = 1,
        transform = 1,
        -- `bitdepth = srgb` from the original was invalid (8/10 only);
        -- if sRGB color management was the intent, use: cm = "srgb"
    },

    extra = {
        output    = "HDMI-A-1",
        mode      = "1920x1080@60.00Hz",
        position  = "4340x0",
        scale     = 1,
        transform = 0,
    },
   -- On the laptop none of the outputs above exist, which is harmless --
   -- eDP-1 just gets defaults. Uncomment to pin it explicitly:
     laptop = { output = "eDP-1", mode = "preferred", position = "auto", scale = 1 },
}

for _, m in pairs(monitors) do
    hl.monitor(m)
end

-- Single source of truth for the monitor setup.
-- When the hardware changes, edit this table and nothing else --
-- hl.monitor, workspace rules, and wayvnc all reference it.
--
-- Field reference: https://wiki.hypr.land/Configuring/Basics/Monitors/

monitors = {
    main = { -- ultrawide
        output    = "DP-2",
        mode      = "3440x1440@180.00Hz",
        position  = "0x0",
        scale     = 1,
        transform = 0,
        bitdepth  = 10,
        vrr       = 1,
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
}

for _, m in pairs(monitors) do
    hl.monitor(m)
end

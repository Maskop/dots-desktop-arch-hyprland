-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "us, cz",
        kb_variant = ", qwerty",
        kb_model   = "ps104",
        kb_options = "grp:alt_shift_toggle, grp:switch, caps:escape",
        kb_rules   = "",

        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0,
    },

    -- !!!!!! Temporary workaround fixed in git commit 6b2c08d !!!!!
    -- (carried over from the original -- worth re-testing whether you
    -- still need it on the BC250)
    cursor = {
        no_hardware_cursors = true,
    },
})

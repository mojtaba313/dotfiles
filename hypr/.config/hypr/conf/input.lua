-- ============================================
-- Input
-- us + ir layouts? keep us default, add toggle example.
-- ============================================
hl.config({
    input = {
        kb_layout = "us,ir",
        kb_variant = ",winkeys",
        kb_model = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules = "",

        follow_mouse = 1,
        mouse_refocus = true,
        sensitivity = 0,
        accel_profile = "flat",
        scroll_method = "edge",

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- ============================================
-- Input - ورودی
-- ============================================

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Gesture (اگه تاچ‌پد داری)
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})

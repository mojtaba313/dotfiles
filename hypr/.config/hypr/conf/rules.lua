-- ============================================
-- Window Rules - قوانین پنجره
-- ============================================

-- جلوگیری از maximize
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- رفع مشکل XWayland drag
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Hyprland-run
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- مثال: پنجره‌های شناور برای بعضی برنامه‌ها
-- hl.window_rule({
--     name  = "float-pavucontrol",
--     match = { class = "pavucontrol" },
--     float = true,
-- })

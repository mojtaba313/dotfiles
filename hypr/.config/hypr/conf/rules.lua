-- ============================================
-- Window Rules — Abyss
-- floats for utilities, tiles for work
-- ============================================

-- suppress maximize events (xwayland compat)
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- xwayland drag fix
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

-- hyprland-run helper
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- floating utilities (size/center/pin are valid window-rule effects)
hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
    size  = "45% 45%",
    center = true,
})

hl.window_rule({
    name  = "float-blueman",
    match = { class = "blueman-manager" },
    float = true,
    size  = "50% 60%",
    center = true,
})

hl.window_rule({
    name  = "float-nm",
    match = { class = "nm-connection-editor" },
    float = true,
    size  = "50% 60%",
    center = true,
})

hl.window_rule({
    name  = "float-rofi",
    match = { class = "^(rofi|Rofi|rofi-wayland|rofi_)$" },
    float = true,
})
hl.window_rule({
    name  = "float-rofi-title",
    match = { title = "^(rofi|Rofi).*" },
    float = true,
})

-- quick notes pad (SUPER+N): floating window on the current workspace
hl.window_rule({
    name  = "notes-pad",
    match = { class = "^(notepad)$" },
    float = true,
    pin = true,
    size  = { "monitor_w*0.3", "monitor_h*0.4" },
    move  = { "monitor_w*0.68", "monitor_h*0.05" },
    border_size = 0,
    no_anim = true,
})

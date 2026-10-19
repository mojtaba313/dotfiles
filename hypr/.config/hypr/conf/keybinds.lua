-- ============================================
-- Keybindings — Abyss setup
-- SUPER = main mod. Mnemonics over muscle-memory.
-- Workspaces 1-5 are named: code / web / term / chat / notes
-- ============================================
local mainMod = "SUPER"

-- --- core apps ---
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu, { float = true }))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + O",      hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(termEditor))

-- --- window control ---
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({
    action = "toggle"
}))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({
    action = "toggle"
}))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())

-- --- bar visibility (state-aware, always tells you what it did) ---
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/barctl.sh toggle"))
-- safety net: if the bar ever goes missing, this always brings it back
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/barctl.sh show"))
-- zen mode: hide the bar + fullscreen the focused window
hl.bind(mainMod .. " + SHIFT + Z", function()
    hl.exec_cmd("~/.config/hypr/scripts/barctl.sh hide")
    hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))
end)

-- --- clipboard (rofi, floats via window rule) ---
-- Ctrl+1 pin / Ctrl+2 unpin inside the menu
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(clipmenu, { float = true }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(clipmenuPin, { float = true }))

-- --- lock / logout / reload (SUPER+L is focus-right, so lock lives on ESC / CTRL+L) ---
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(lockCmd))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(lockCmd))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(logoutMenu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && notify-send 'Hyprland' 'Config reloaded'"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- --- move focus (arrows + vim HJKL) ---
hl.bind(mainMod .. " + left", hl.dsp.focus({
    direction = "left"
}))
hl.bind(mainMod .. " + right", hl.dsp.focus({
    direction = "right"
}))
hl.bind(mainMod .. " + up", hl.dsp.focus({
    direction = "up"
}))
hl.bind(mainMod .. " + down", hl.dsp.focus({
    direction = "down"
}))
hl.bind(mainMod .. " + H", hl.dsp.focus({
    direction = "left"
}))
hl.bind(mainMod .. " + L", hl.dsp.focus({
    direction = "right"
}))
hl.bind(mainMod .. " + K", hl.dsp.focus({
    direction = "up"
}))

-- --- move windows ---
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({
    direction = "left"
}))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({
    direction = "right"
}))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({
    direction = "left"
}))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({
    direction = "right"
}))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({
    direction = "up"
}))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({
    direction = "down"
}))

-- --- workspaces 1-10 ---
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({
        workspace = i
    }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({
        workspace = i
    }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({
        workspace = i,
        silent = true
    }))
end

-- --- switch workspaces with SUPER + CTRL + arrows ---
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({
    workspace = "+1"
}))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({
    workspace = "-1"
}))
-- --- switch workspaces and move window with SUPER + CTRL + arrows ---
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.move({
    workspace = "+1"
}))
hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.move({
    workspace = "-1"
}))
-- --- switch workspaces with SUPER + CTRL + arrows ---
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({
    workspace = "+1"
}))
hl.bind(mainMod .. " + ALT + left", hl.dsp.focus({
    workspace = "-1"
}))

-- --- switch workspaces with SUPER + CTRL + mouse scroll ---
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.focus({
    workspace = "+1"
}))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.focus({
    workspace = "-1"
}))

-- --- switch workspaces with SUPER + CTRL + mouse click ---
hl.bind(mainMod .. " + CTRL + mouse:272", hl.dsp.focus({
    workspace = "-1"
}))
hl.bind(mainMod .. " + CTRL + mouse:273", hl.dsp.focus({
    workspace = "+1"
}))

-- --- switch workspaces and move window with SUPER + CTRL + SHIFT + mouse click ---
hl.bind(mainMod .. " + CTRL + SHIFT + mouse:272", hl.dsp.window.move({
    workspace = "-1"
}))
hl.bind(mainMod .. " + CTRL + SHIFT + mouse:273", hl.dsp.window.move({
    workspace = "+1"
}))

-- --- scratchpad ("magic") ---
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({
    workspace = "special:magic"
}))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({
    workspace = "previous"
}))

-- --- workspace scroll ---
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({
    workspace = "e+1"
}))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({
    workspace = "e-1"
}))

-- --- mouse drag / resize ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true
})
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), {
    mouse = true
})

-- --- audio / brightness / media ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {
    locked = true,
    repeating = true
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
    locked = true,
    repeating = true
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
    locked = true,
    repeating = true
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {
    locked = true,
    repeating = true
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), {
    locked = true,
    repeating = true
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), {
    locked = true,
    repeating = true
})

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true
})
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true
})
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true
})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true
})

-- --- screenshots (grim + slurp + wl-copy, save + notify) ---
hl.bind("Print",
    hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Region copied to clipboard'"))
hl.bind("SHIFT + Print",
    hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'Screenshot' 'Fullscreen copied to clipboard'"))
hl.bind(mainMod .. " + Print",
    hl.dsp.exec_cmd("mkdir -p " .. screenshotDir .. " && grim -g \"$(slurp)\" " .. screenshotDir ..
                        "/$(date +%Y%m%d-%H%M%S).png && notify-send 'Screenshot' 'Saved to ~/Pictures/Screenshots'"))

-- --- notifications: dismiss (mako/swaync) ---
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("makoctl dismiss || swaync-client -cp || true"))

-- --- night-shift eye care: toggle warm tint via gammastep ---
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(
    "(pgrep -x gammastep >/dev/null && pkill gammastep || (gammastep -O 3500 & disown)); notify-send '󰔟 Night shift' 'Warm tint 3500K toggled'"
))

-- --- most used directories ---
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("dolphin $MEDICAL_DIR"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("dolphin $PROJECTS_DIR"))

-- --- v2rayN ---
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("v2rayN"))

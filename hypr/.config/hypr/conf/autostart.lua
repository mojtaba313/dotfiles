-- ============================================
-- Autostart
-- mako is used (installed). dunst line removed.
-- This block re-runs on `hyprctl reload`, so every
-- daemon is guarded against duplicate spawning.
-- ============================================

local function is_running(pgrep_args)
    local ok, handle = pcall(io.popen, "pgrep " .. pgrep_args .. " 2>/dev/null")
    if not ok or not handle then return false end
    local out = handle:read("*a") or ""
    handle:close()
    return out:match("%S") ~= nil
end

-- start cmd only if nothing matches this pgrep pattern
local function once(pgrep_args, cmd)
    if is_running(pgrep_args) then return end
    hl.exec_cmd(cmd)
end

hl.on("hyprland.start", function()
    -- bar + wallpaper + notifications
    once("-x waybar", "waybar")
    once("-x hyprpaper", "hyprpaper")
    once("-x mako", "mako")

    once("systemctl --user start hyprpolkitagent")

    -- clipboard history: clipwatch supervises `wl-paste --watch cliphist store`
    -- and restarts it if it dies (see the script for why --type is banned)
    once("scripts/clipwatch.sh", "~/.config/hypr/scripts/clipwatch.sh")

    -- applets
    once("-x nm-applet", "nm-applet --indicator")
    once("-x blueman-applet", "blueman-applet")

    -- auth agent for password dialogs
    once("-f polkit-gnome-authentication-agent-1",
         "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- idle / lock daemon
    once("-x hypridle", "hypridle")

    -- warm-light daemon (starts off; toggle with SUPER+SHIFT+N)
    -- hl.exec_cmd("gammastep -O 3500")

    -- kde connect (optional)
    -- hl.exec_cmd("kdeconnect-indicator")

    -- screenshots dir
    hl.exec_cmd("mkdir -p ~/Pictures/Screenshots")
end)

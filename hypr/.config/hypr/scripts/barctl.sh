#!/usr/bin/env bash
# ============================================
# barctl.sh — reliable waybar show / hide / restart
#
# Why this exists: waybar's SIGUSR1 toggle is stateless. Hide the bar once and
# it stays invisible while still occupying its layer-shell surface — every
# click on the "buttons" then lands on the window behind it, which looks
# exactly like a broken, unclickable bar.
#
# This script keeps state, always tells you what it did, and restores the bar
# by restarting it (deterministic) instead of blindly toggling.
#
# Usage: barctl.sh [show|hide|toggle|restart|status]
# ============================================
set -uo pipefail

STATE="${XDG_RUNTIME_DIR:-/tmp}/waybar-barctl.state"

read_state() { cat "$STATE" 2>/dev/null || echo 1; }
write_state() { printf '%s' "$1" > "$STATE"; }

notify() {
    local msg="$1" urg="${2:-normal}" sub="${3:-}"
    notify-send -a "waybar" -u "$urg" "$msg" "$sub" >/dev/null 2>&1 || true
}

bar_running() { pgrep -x waybar >/dev/null 2>&1; }

start_bar() {
    # detached so it survives the caller (Hyprland exec / keybind) exiting
    (setsid waybar >/dev/null 2>&1 </dev/null &)
    sleep 0.6
}

# Showing always restarts: a restart is the only way to be *sure* the bar is
# really on screen (covers hidden-by-toggle, crashed, and stale instances).
show_bar() {
    if bar_running; then
        pkill -x waybar >/dev/null 2>&1
        sleep 0.3
    fi
    start_bar
    write_state 1
    if bar_running; then
        notify "󰍪 Bar shown" "waybar restarted and visible"
    else
        notify "󰍪 Bar failed to start" "check: waybar" critical
    fi
}

hide_bar() {
    if ! bar_running; then
        write_state 0
        notify "󰍪 Bar already stopped" "SUPER+Z will bring it back"
        return
    fi
    pkill -SIGUSR1 waybar >/dev/null 2>&1
    write_state 0
    notify "󰍪 Bar hidden" "SUPER+Z to show it again" low
}

case "${1:-toggle}" in
    show|restart)
        show_bar
        ;;
    hide)
        hide_bar
        ;;
    toggle)
        if [[ $(read_state) == 1 ]]; then hide_bar; else show_bar; fi
        ;;
    status)
        if bar_running && [[ $(read_state) == 1 ]]; then
            echo "visible"
        else
            echo "hidden"
        fi
        ;;
    *)
        echo "Usage: barctl.sh [show|hide|toggle|restart|status]" >&2
        exit 1
        ;;
esac
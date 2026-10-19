#!/usr/bin/env bash
# ============================================
# wsbtn.sh — workspace buttons for waybar
#
# Why this exists: waybar's built-in hyprland/workspaces module talks to
# Hyprland over its own IPC socket, and Hyprland 0.55+ (this box runs 0.56)
# replaced that socket's protocol with Hyprwire. waybar 0.15 does not speak
# Hyprwire, so its "activate" action is silently rejected.
#
# Fix: drive the compositor with `hyprctl` instead, and read the active
# workspace from scripts/wswatch.sh's state file. Clicks and events then poke
# waybar with SIGRTMIN+8 so the highlight repaints immediately.
#
# In 0.55+ dispatch arguments are parsed as Lua. `hyprctl dispatch` already
# implies hl.dispatch(), so pass a dispatcher directly:
#     hl.dsp.focus({ workspace = 3 })
#
# Usage:
#   wsbtn.sh <n>          render button JSON for workspace n (waybar exec)
#   wsbtn.sh <n> go       switch to workspace n            (waybar on-click)
#   wsbtn.sh next|prev    move one workspace over
# ============================================
set -uo pipefail

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-ws/active"
SIGNAL=8

dispatch() {
  # $1 = lua argument table for hl.dsp.focus
  hyprctl dispatch "hl.dsp.focus($1)" >/dev/null 2>&1 || true
}

refresh_bar() {
  pkill -RTMIN+"$SIGNAL" -x waybar 2>/dev/null || true
}

# Keep the state file in sync immediately so the bar repaints right away,
# then tell waybar to re-run the workspace modules instead of waiting a tick.
mark_active() {
    mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null
    printf '%s %s' "$1" "$(printf '%(%s)T' -1)" > "$STATE_FILE"
    refresh_bar
}

case "${1:-}" in
  next)
    dispatch '{ workspace = "e+1" }'
    exit 0
    ;;
  prev)
    dispatch '{ workspace = "e-1" }'
    exit 0
    ;;
esac

case "${2:-render}" in
  go)
    dispatch "{ workspace = $1 }"
    mark_active "$1"
    exit 0
    ;;
esac

ws="$1"
# Icons are emitted with printf \U escapes: private-use glyphs are easy to
# lose when this file is edited or synced (ws2/ws3 were empty for a while).
case $ws in
  1) icon=$(printf '\U000f0a1e') ;;  # code
  2) icon=$(printf '\U000f059f') ;;  # web
  3) icon=$(printf '\U000f018d') ;;  # console
  4) icon=$(printf '\U000f066f') ;;  # chat
  5) icon=$(printf '\U000f0219') ;;  # file
  *) icon=$(printf '\U000f111') ;;
esac

# Hot path: read "<workspace> <epoch>" written by wswatch.sh. Pure bash builtins
# (no stat/date forks). Fall back to hyprctl only if the watcher is dead.
active=""
if [[ -r $STATE_FILE ]]; then
    IFS=' ' read -r active stamp < "$STATE_FILE" 2>/dev/null || true
    if [[ -z ${active:-} || -z ${stamp:-} ]] || (( $(printf '%(%s)T' -1) - stamp > 15 )); then
        active=""   # watcher missing or stale -> slow path
    fi
fi
[[ -n $active ]] || active=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.name' 2>/dev/null)

cls=""
[[ $active == "$ws" ]] && cls="active"

printf '{"text":"%s %s","class":"%s","tooltip":"workspace %s"}\n' "$ws" "$icon" "$cls" "$ws"

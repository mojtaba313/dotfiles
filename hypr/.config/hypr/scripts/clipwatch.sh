#!/usr/bin/env bash
# ============================================
# clipwatch.sh — keep clipboard history capture alive
#
# The capture itself is one long-running command:
#     wl-paste --watch cliphist store
#
# Two hard-won details:
#   1. NO --type flag. `--type text` asks for a MIME type named exactly "text",
#      which virtually nothing offers (kitty, browsers and Chromium all offer
#      text/plain;charset=utf-8). The watcher still starts, but never matches
#      an offer, so copies are silently never recorded.
#   2. The watcher can die (compositor restart, seat change, transient error)
#      and nothing restarts it. This supervisor restarts it, so a dead watcher
#      can never silently stop clipboard history again.
#
# Started (once) from hyprland's autostart.
# ============================================
set -uo pipefail

# The child gets its own session and fully detached stdio: when this script is
# spawned by the compositor rather than a shell, an inherited/unavailable stdin
# makes `wl-paste --watch` exit immediately and the loop spins uselessly.
while :; do
    setsid wl-paste --watch cliphist store </dev/null >/dev/null 2>&1
    sleep 1
done
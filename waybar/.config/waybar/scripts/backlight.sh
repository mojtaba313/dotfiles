#!/usr/bin/env bash
# ============================================
# backlight.sh — brightness control for waybar
#
# Usage:
#   backlight.sh                 render JSON (waybar exec)
#   backlight.sh up|down         step brightness by 5%
#   backlight.sh toggle          100% <-> 30%
#
# Click  : toggle between full and dim (good for reading charts/notes)
# Scroll : step up/down
#
# Icons are emitted with printf \u escapes: private-use-area glyphs are easy to
# lose when this file is edited or synced, and an empty icon renders as a
# stray space.
# ============================================
set -uo pipefail

DEV="$(brightnessctl --list 2>/dev/null | sed -n "s/^Device '\([^']*\)'.*/\1/p" | head -n1)"
[[ -n $DEV ]] || DEV="intel_backlight"

get_pct() {
    local cur max
    cur=$(cat "/sys/class/backlight/$DEV/brightness" 2>/dev/null) || { echo 0; return; }
    max=$(cat "/sys/class/backlight/$DEV/max_brightness" 2>/dev/null) || max=1
    ((max > 0)) || max=1
    echo $(( cur * 100 / max ))
}

step() {
    brightnessctl --device="$DEV" set "$1"% >/dev/null 2>&1 || true
}

case "${1:-render}" in
  up)
    step $(( $(get_pct) + 5 ))
    exit 0
    ;;
  down)
    step $(( $(get_pct) - 5 ))
    exit 0
    ;;
  toggle)
    pct=$(get_pct)
    if ((pct > 40)); then
      step 30
    else
      step 100
    fi
    exit 0
    ;;
esac

pct=$(get_pct)

# icon steps down as the panel gets dimmer (glyphs verified against the font)
if   ((pct >= 66)); then icon=$(printf '\uf185')   # sun
elif ((pct >= 33)); then icon=$(printf '\uf0eb')   # lightbulb
else                     icon=$(printf '\uf186')   # moon
fi

# amber when dim, so a night-time reading light is obvious at a glance
if ((pct < 50)); then cls="dim"; else cls=""; fi

printf '{"text":"%s %d%%","class":"%s","tooltip":"brightness %d%%\\nclick: 100%% / 30%%\\nscroll: ±5%%"}\n' \
  "$icon" "$pct" "$cls" "$pct"
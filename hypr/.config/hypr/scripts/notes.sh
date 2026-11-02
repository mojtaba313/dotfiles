#!/usr/bin/env bash
# Toggle the pinned notes pad (visible on every workspace).
set -euo pipefail

NOTE_CLASS="notepad"
SEL="class:^notepad$"
STATE="${XDG_RUNTIME_DIR:-/tmp}/hypr-notes-pad.pos"
OFFSCREEN=20000

note_at() {
    hyprctl clients -j | jq -r --arg c "$NOTE_CLASS" \
        'first(.[] | select(.class == $c)) | "\(.at[0]) \(.at[1])"' 2>/dev/null | head -n1
}

if [ -z "$(note_at)" ]; then
    kitty --class "$NOTE_CLASS" --title NotePad \
        nvim -u ~/.config/nvim/minimal.vim ~/notes.txt >/dev/null 2>&1 &

    for _ in $(seq 1 100); do
        if [ -n "$(note_at)" ]; then
            break
        fi
        sleep 0.1
    done

    hyprctl dispatch "hl.dsp.focus({ window = \"$SEL\" })" >/dev/null || true
    exit 0
fi

read -r x y <<< "$(note_at)"

if [ "$x" -ge 10000 ]; then
    if [ -f "$STATE" ] && read -r px py < "$STATE" && [ -n "${px:-}" ] && [ -n "${py:-}" ]; then
        :
    else
        read -r px py < <(hyprctl monitors -j | jq -r \
            '.[] | select(.focused) | "\((.width/.scale*0.68)|floor) \((.height/.scale*0.05)|floor)"')
    fi

    hyprctl dispatch "hl.dsp.window.move({ x = $px, y = $py, relative = false, window = \"$SEL\" })" >/dev/null
    hyprctl dispatch "hl.dsp.window.pin({ action = \"enable\", window = \"$SEL\" })" >/dev/null
    hyprctl dispatch "hl.dsp.focus({ window = \"$SEL\" })" >/dev/null || true
else
    printf '%s %s\n' "$x" "$y" > "$STATE"
    hyprctl dispatch "hl.dsp.window.pin({ action = \"disable\", window = \"$SEL\" })" >/dev/null
    hyprctl dispatch "hl.dsp.window.move({ x = $OFFSCREEN, y = $OFFSCREEN, relative = false, window = \"$SEL\" })" >/dev/null
fi

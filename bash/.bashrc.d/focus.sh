# ~/.bashrc.d/focus.sh — for dev + physician life
# pomodoro in terminal, 20-20-20 eyes, hydration, quick notes
# pairs with waybar custom/focus + custom/eyecare modules

FOCUS_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/focus"
mkdir -p "$FOCUS_DIR" 2>/dev/null || true

# focus [minutes] — terminal pomodoro with notify
focus() {
    local mins="${1:-25}"
    local end=$(( $(date +%s) + mins * 60 ))
    echo "$end" > "${XDG_RUNTIME_DIR:-/tmp}/waybar-focus/end" 2>/dev/null || true
    echo "󰽉 focusing $mins min — one task. (Ctrl+C to stop early)"
    while (( $(date +%s) < end )); do
        local left=$(( end - $(date +%s) ))
        printf "\r󰽉 %02d:%02d left" $((left/60)) $((left%60))
        sleep 1
    done
    echo -e "\n󰽉 done — stand, hydrate, look far away."
    notify-send "󰽉 Focus complete" "Stand, hydrate, look far away." 2>/dev/null || true
    rm -f "${XDG_RUNTIME_DIR:-/tmp}/waybar-focus/end" 2>/dev/null || true
}

# eye break now
eyes() {
    notify-send "󰔟 20-20-20" "Look 20ft away for 20s. Blink slowly." 2>/dev/null || true
    echo "󰔟 look 20ft away for 20s…"
    sleep 20
    notify-send "󰔟 Welcome back" "Blink a few times. Hydrate." 2>/dev/null || true
}

# hydrate log: hydrate [ml]
hydrate() {
    local ml="${1:-250}"
    local file="$FOCUS_DIR/hydrate-$(date +%F).log"
    echo "$(date +%H:%M) +${ml}ml" >> "$file"
    local total
    total=$(awk -F'[+m]' '{s+=$2} END {print s+0}' "$file")
    echo "💧 +${ml}ml today → ${total}ml total"
}

# quick clinical / study note: note "post-call: ..." (timestamped markdown)
note() {
    local dir="$HOME/Documents/notes"
    mkdir -p "$dir"
    local file="$dir/$(date +%F).md"
    if [ $# -eq 0 ]; then
        ${EDITOR:-nvim} "$file"
    else
        printf -- "- [%s] %s\n" "$(date +%H:%M)" "$*" >> "$file"
        echo "noted → $file"
    fi
}

# med-note: structured stub for learning (not for real PHI!)
med-note() {
    local dir="$HOME/Documents/notes/cases"
    mkdir -p "$dir"
    local file="$dir/$(date +%F-%H%M)-study.md"
    cat > "$file" <<'EOF'
# Study note — __DATE__

## Presentation

## Key findings

## DDx

## Plan / learning point

## Follow-up
EOF
    sed -i "s/__DATE__/$(date +%F)/" "$file"
    ${EDITOR:-nvim} "$file"
}

# standup: yesterday/today/blockers stub for dev teams
standup() {
    local file="$FOCUS_DIR/standup-$(date +%F).md"
    [ -f "$file" ] || printf "# Standup %s\n\n## Yesterday\n- \n\n## Today\n- \n\n## Blockers\n- \n" "$(date +%F)" > "$file"
    ${EDITOR:-nvim} "$file"
}

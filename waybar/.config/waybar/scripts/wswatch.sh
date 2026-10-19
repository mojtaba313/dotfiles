#!/usr/bin/env bash
# ============================================
# wswatch.sh — publish the active workspace for the waybar buttons
#
# Listens on Hyprland's socket2 event stream instead of polling, so a
# workspace switch (keyboard or click) updates the buttons instantly:
# write the state file, then poke waybar with SIGRTMIN+8 (the ws modules
# subscribe to it). A 10s idle heartbeat keeps the state file "fresh" for
# wsbtn.sh's staleness check without spawning hyprctl in a loop.
#
# If socat or the event socket is unavailable it degrades to a 1s poll.
# Started (once) from hyprland's autostart. Safe to kill: the buttons fall
# back to hyprctl if the state file goes stale.
# ============================================
set -uo pipefail

DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar-ws"
ACTIVE="$DIR/active"
SIGNAL=8
mkdir -p "$DIR"

SIG="${HYPRLAND_INSTANCE_SIGNATURE:-}"
SOCK="${XDG_RUNTIME_DIR:-/tmp}/hypr/$SIG/.socket2.sock"

publish() {
    local ws="$1"
    [[ -z $ws ]] && return
    printf '%s %s' "$ws" "$(printf '%(%s)T' -1)" > "$ACTIVE.tmp" && mv -f "$ACTIVE.tmp" "$ACTIVE"
    pkill -RTMIN+"$SIGNAL" -x waybar 2>/dev/null || true
}

heartbeat() {
    local cur
    [[ -r $ACTIVE ]] || return
    read -r cur _ < "$ACTIVE" || true
    [[ -n ${cur:-} ]] && printf '%s %s' "$cur" "$(printf '%(%s)T' -1)" > "$ACTIVE.tmp" && mv -f "$ACTIVE.tmp" "$ACTIVE"
}

# Seed the current workspace.
if command -v hyprctl >/dev/null; then
    publish "$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.name // empty' 2>/dev/null)"
fi

# Fallback: no event socket (or no socat) -> cheap once-a-second poll.
if [[ -z $SIG || ! -S $SOCK ]] || ! command -v socat >/dev/null; then
    last=""
    while :; do
        cur=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.name' 2>/dev/null)
        if [[ -n $cur && $cur != "$last" ]]; then
            publish "$cur"
            last="$cur"
        fi
        sleep 1
    done
    exit 0
fi

connect() {
    exec 3< <(socat -U - "UNIX-CONNECT:$SOCK" 2>/dev/null)
}
connect

handle_event() {
    local ev="$1" val name
    case $ev in
        workspacev2\>\>*)
            val="${ev#workspacev2>>}"
            name="${val#*,}"
            publish "$name"
            ;;
        focusedmon\>\>*)
            val="${ev#focusedmon>>}"
            name="${val#*,}"
            publish "$name"
            ;;
        workspace\>\>*)
            name="${ev#workspace>>}"
            publish "$name"
            ;;
    esac
}

while :; do
    if IFS= read -r -t 10 -u 3 line; then
        [[ -n $line ]] && handle_event "$line"
    else
        rc=$?
        if (( rc > 128 )); then
            # Timed out with no events: keep the state file fresh.
            heartbeat
        else
            # Event stream closed (compositor restart etc.). Reconnect,
            # slowing down so a dead socket can't become a busy loop.
            sleep 1
            connect
        fi
    fi
done

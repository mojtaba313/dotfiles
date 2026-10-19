#!/usr/bin/env bash
# ============================================
# clipmenu.sh — clipboard history with PIN support
#
#   clipmenu.sh            history + pinned (pins listed first)
#   clipmenu.sh --pinned   pinned entries only
#
# Rofi keys:
#   Enter        copy selection to clipboard (and paste it back)
#   Ctrl+1       pin the highlighted entry   (stays forever)
#   Ctrl+2       unpin / remove the entry
#   Ctrl+Shift+W clear all pins
#
# CLIPMENU_PASTE=0 disables the automatic paste-back (copy only).
# ============================================
set -uo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/clipmenu"
PINS="$STATE_DIR/pinned.tsv"
ROFI_THEME="$HOME/.config/rofi/abyss-cyan.rasi"
ROFI_CLIP_THEME="$HOME/.config/rofi/clipmenu.rasi"
MODE="${1:-all}"

mkdir -p "$STATE_DIR"
touch "$PINS"

enc() { printf '%s' "$1" | base64 -w0; }
dec() { printf '%s' "$1" | base64 -d 2>/dev/null; }
_flatten() { local s="$1"; s="${s//$'\n'/ }"; s="${s//$'\r'/ }"; s="${s//$'\t'/ }"; printf '%s' "${s:0:120}"; }
one_line() { _flatten "$1"; }
notify() { notify-send -a "clipmenu" "$@" >/dev/null 2>&1 || true; }

# ---------- pinned entries ----------
pin_texts=()
if [[ -s $PINS ]]; then
  while IFS=$'\t' read -r _ts b64; do
    [[ -z ${b64:-} ]] && continue
    pin_texts+=("$(dec "$b64")")
  done < "$PINS"
fi

# ---------- history entries ----------
hist_ids=()
hist_previews=()
hist_bin=()
hist_mime=()
if [[ $MODE != "--pinned" ]]; then
  mapfile -t hist_raw < <(cliphist list 2>/dev/null | head -n 300)
  for line in "${hist_raw[@]}"; do
    [[ -z $line ]] && continue
    hist_ids+=("${line%%$'\t'*}")
    preview="${line#*$'\t'}"
    [[ $preview == "$line" ]] && preview="$line"
    preview="${preview//$'\n'/ }"
    preview="${preview//$'\r'/ }"
    preview="${preview//$'\t'/ }"
    hist_previews+=("${preview:0:120}")
    if [[ $preview == *"binary data"* ]]; then
      hist_bin+=(1)
      ext=""
      [[ $preview =~ ([A-Za-z0-9]+)\ [0-9]+x[0-9]+ ]] && ext="${BASH_REMATCH[1],,}"
      case "$ext" in
        png)         hist_mime+=("image/png") ;;
        jpg|jpeg)    hist_mime+=("image/jpeg") ;;
        gif)         hist_mime+=("image/gif") ;;
        webp)        hist_mime+=("image/webp") ;;
        bmp)         hist_mime+=("image/bmp") ;;
        svg)         hist_mime+=("image/svg+xml") ;;
        *)           hist_mime+=("application/octet-stream") ;;
      esac
    else
      hist_bin+=(0)
      hist_mime+=("")
    fi
  done
  unset hist_raw
fi

# ---------- build display list ----------
display=()
kinds=()
keys=()
pinnable=()
copy_bin=()
copy_mime=()
for i in "${!pin_texts[@]}"; do
  display+=("📌  $(_flatten "${pin_texts[$i]}")")
  kinds+=("pin")
  keys+=("$i")
  pinnable+=(1)
  copy_bin+=(0)
  copy_mime+=("")
done
for i in "${!hist_previews[@]}"; do
  display+=("${hist_previews[$i]}")
  kinds+=("hist")
  keys+=("${hist_ids[$i]}")
  pinnable+=("$(( hist_bin[i] == 0 ))")
  copy_bin+=("${hist_bin[$i]}")
  copy_mime+=("${hist_mime[$i]}")
done

if ((${#display[@]} == 0)); then
  notify "󰐑 Clipboard" "Nothing to paste yet — copy something first."
  exit 0
fi

# grab focus before rofi takes it
prev_addr=""
prev_class=""
info=$(hyprctl -j activewindow 2>/dev/null) || true
prev_addr=$(printf '%s' "$info" | jq -r '.address // empty' 2>/dev/null)
prev_class=$(printf '%s' "$info" | jq -r '.class // empty' 2>/dev/null)

# rofi prints the selected line (format 'i' = its index). A custom key is
# signalled through the exit status: 10 for -kb-custom-1, 11 for -custom-2, ...
list_file=$(mktemp)
out_file=$(mktemp)
printf '%s\n' "${display[@]}" > "$list_file"
rofi \
  -dmenu \
  -no-custom \
  -format 'i' \
  -mesg "⏎ copy   ·   Ctrl+1 pin   ·   Ctrl+2 unpin   ·   Ctrl+Shift+W clear pins" \
  -kb-custom-1 "Ctrl+1" \
  -kb-custom-2 "Ctrl+2" \
  -kb-custom-3 "Ctrl+Shift+w" \
  -theme "$ROFI_CLIP_THEME" < "$list_file" > "$out_file"
rofi_rc=$?
mapfile -t out < "$out_file"
rm -f "$list_file" "$out_file"

((${#out[@]} > 0)) || exit 0

action=""
case "$rofi_rc" in
  10) action="custom1" ;;
  11) action="custom2" ;;
  12) action="custom3" ;;
esac
# Fallback for rofi builds that print the custom key name instead.
if [[ -z $action ]]; then
  for line in "${out[@]}"; do
    case "$line" in custom*) action="$line"; break ;; esac
  done
fi

sel=""
for line in "${out[@]}"; do
  case "$line" in
    ''|*[!0-9]*) : ;;
    *) [[ -z $sel ]] && sel="$line" ;;
  esac
done
[[ -n $sel && $sel =~ ^[0-9]+$ ]] || exit 0
(($sel < ${#display[@]})) || exit 0

kind="${kinds[$sel]}"
key="${keys[$sel]}"

row_text() {
  if [[ $1 == "pin" ]]; then printf '%s' "${pin_texts[$2]}"; else cliphist decode "$2" 2>/dev/null; fi
}

# Pipe bytes straight through: bash variables mangle binary/embedded newlines,
# and wl-copy must be told the real MIME type for images. For text, no --type
# (the default text/plain;charset=utf-8 is what applications actually request;
# `--type text` offers a bogus MIME type and paste silently fails).
copy_selected() {
  local ckind="$1" ckey="$2" idx="$3" tmpf preview
  if [[ $ckind == "pin" ]]; then
    printf '%s' "${pin_texts[$ckey]}" | wl-copy
    notify -u low "󰐑 Copied" "$(one_line "${pin_texts[$ckey]}")"
    return
  fi
  tmpf=$(mktemp)
  cliphist decode "$ckey" > "$tmpf" 2>/dev/null || true
  if (( ${copy_bin[$idx]} )); then
    wl-copy --type "${copy_mime[$idx]}" < "$tmpf"
    notify -u low "󰐑 Copied" "image · ${copy_mime[$idx]}"
  else
    wl-copy < "$tmpf"
    preview=$(<"$tmpf")
    notify -u low "󰐑 Copied" "$(one_line "$preview")"
  fi
  rm -f "$tmpf"
}

case "$action" in
  custom1)
    if ((${pinnable[$sel]} == 0)); then notify "󰐑 Cannot pin" "Images/binary entries can only be copied, not pinned."; exit 0; fi
    text="$(row_text "$kind" "$key")"
    [[ -n $text ]] && { printf '%s\t%s\n' "$(date +%s)" "$(enc "$text")" >> "$PINS"; notify -u low "󰐑 Pinned" "$(one_line "$text")"; }
    ;;
  custom2)
    if [[ $kind == "pin" ]]; then
      text="${pin_texts[$key]}"
      b64="$(enc "$text")"
      grep -v -F "$b64" "$PINS" > "$PINS.tmp" 2>/dev/null || true
      mv "$PINS.tmp" "$PINS"
      notify "󰐑 Unpinned" "$(one_line "$text")"
    else
      # cliphist delete reads the matching list line(s) on stdin; it does not
      # take an id argument (passing one silently deleted nothing).
      if (( ${copy_bin[$sel]} )); then
        cliphist list 2>/dev/null | grep -a "^${key}"$'\t' | cliphist delete >/dev/null 2>&1 || true
        notify "󰐑 Removed" "image · ${copy_mime[$sel]}"
      else
        text="$(cliphist decode "$key" 2>/dev/null)"
        cliphist list 2>/dev/null | grep -a "^${key}"$'\t' | cliphist delete >/dev/null 2>&1 || true
        notify "󰐑 Removed" "$(one_line "$text")"
      fi
    fi
    ;;
  custom3)
    choice=$(rofi -dmenu -mesg "Remove every pinned clipboard entry?" -theme "$ROFI_THEME" <<< "No, keep them
Yes, clear all pins")
    [[ $choice == "Yes, clear all pins" ]] && { : > "$PINS"; notify "󰐑 Pins cleared" "All pinned entries removed"; }
    ;;
  *)
    copy_selected "$kind" "$key" "$sel"
    # paste back into the window that had focus before the menu opened
    if [[ ${CLIPMENU_PASTE:-1} != 0 && -n $prev_addr ]]; then
      mods="CTRL"; vkey="v"
      case ${prev_class,,} in kitty|ghostty|wezterm|foot|alacritty) mods="CTRL+SHIFT" ;; esac
      sleep 0.2
      hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"$mods\", key = \"$vkey\", window = \"address:$prev_addr\" })" >/dev/null 2>&1 || true
    fi
    ;;
esac

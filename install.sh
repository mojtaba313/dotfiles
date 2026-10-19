#!/usr/bin/env bash
# install.sh — stow Abyss Cyan dotfiles (Arch)
set -euo pipefail
cd "$(dirname "$0")"

say() { printf "\033[1;36m==>\033[0m %s\n" "$*"; }

say "Checking stow…"
command -v stow >/dev/null || { echo "install stow first: sudo pacman -S stow"; exit 1; }

say "Stowing packages…"
for pkg in */; do
  pkg="${pkg%/}"
  [[ "$pkg" == "wallpapers" ]] && continue
  [[ "$pkg" == ".git" ]] && continue
  [[ "$pkg" == "git" ]] && continue
  [ -d "$pkg" ] || continue
  say "  stow $pkg"
  stow --restow "$pkg"
done

say "Linking wallpapers → ~/Pictures/Wallpapers…"
mkdir -p ~/Pictures/Wallpapers ~/Pictures/Screenshots ~/Documents/notes
ln -sf "$PWD/wallpapers/abyss-cyan.jpg" ~/Pictures/Wallpapers/abyss-cyan.jpg
ln -sf "$PWD/wallpapers/abyss-cyan-vertical.jpg" ~/Pictures/Wallpapers/abyss-cyan-vertical.jpg
# drop the old PNG wallpapers if they are still linked
rm -f ~/Pictures/Wallpapers/abyss-cyan.png ~/Pictures/Wallpapers/abyss-cyan-vertical.png

say "Making scripts executable…"
chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null || true
chmod +x ~/.config/rofi/rofi-power-menu 2>/dev/null || true

say "Reloading (if running)…"
command -v hyprctl >/dev/null && hyprctl reload 2>/dev/null || true
# bar: SIGUSR2 reloads in place; barctl.sh show guarantees it is visible
pkill -SIGUSR2 waybar 2>/dev/null || ~/.config/hypr/scripts/barctl.sh show 2>/dev/null || true
pkill -x mako >/dev/null 2>&1 && (mako &>/dev/null & disown) || true
makoctl reload 2>/dev/null || true

say "Done. Open a new kitty tab to load starship + bash modules."
say "Cheatsheet: SUPER+Return kitty • SUPER+R rofi • SUPER+ESC lock • SUPER+Z hide bar • SUPER+Print screenshot"

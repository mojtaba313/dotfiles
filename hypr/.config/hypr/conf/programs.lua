-- ============================================
-- Programs — single source of truth
-- swap any of these, keybinds follow automatically
-- ============================================

terminal    = "kitty"
fileManager = "dolphin"
menu        = "rofi -show drun -theme ~/.config/rofi/abyss-cyan.rasi"
browser     = "firefox"
editor      = "code"
-- editor fallback for terminal: nvim
termEditor  = "kitty -e nvim"
notesToggle = "~/.config/hypr/scripts/notes.sh"
lockCmd     = "hyprlock"
logoutMenu  = "rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu -theme ~/.config/rofi/abyss-cyan.rasi"
clipmenu    = "~/.config/hypr/scripts/clipmenu.sh"
clipmenuPin = "~/.config/hypr/scripts/clipmenu.sh --pinned"
screenshotDir = "~/Pictures/Screenshots"

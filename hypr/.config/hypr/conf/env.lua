-- ============================================
-- Environment Variables
-- ============================================

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "BreezeX-Dark")

-- Wayland-native apps
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Electron / VS Code / Chromium Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("NIXOS_OZONE_WL", "1")

-- Qt scaling (keep 1, tune per monitor in monitors.lua)
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_FONT_DPI", "96")

-- Theme hints so GTK/Qt follow the dark cyan look
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- File pickers: route GTK apps through the XDG portal, and give Qt apps the
-- KDE platform theme so they use the Dolphin/KDE file dialog.
-- portals.conf selects the KDE backend for FileChooser.
hl.env("GTK_USE_PORTAL", "1")
hl.env("QT_QPA_PLATFORMTHEME", "kde")

-- Work directories (also set for the shell in ~/.bashrc.d/vars.sh)
hl.env("MEDICAL_DIR", "/home/mojtaba/Desktop/medicine")
hl.env("PROJECTS_DIR", "/home/mojtaba/Desktop/projects")

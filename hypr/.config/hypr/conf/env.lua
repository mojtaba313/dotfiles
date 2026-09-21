-- ============================================
-- Environment Variables - متغیرهای محیطی
-- ============================================

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- برای Wayland-native بودن برنامه‌ها
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- ============================================
-- Autostart - اجرای خودکار
-- ============================================

hl.on("hyprland.start", function()
    -- نوار وضعیت
    hl.exec_cmd("waybar")

    -- والپیپر
    hl.exec_cmd("hyprpaper")

    -- نوتیفیکیشن
    hl.exec_cmd("dunst")

    -- کلیپ‌بورد
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Network applet
    hl.exec_cmd("nm-applet --indicator")

    -- Bluetooth applet
    hl.exec_cmd("blueman-applet")

    -- Policykit (برای دیالوگ‌های رمز)
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Idle daemon (قفل خودکار صفحه)
    hl.exec_cmd("hypridle")

    -- اگه از KDE Connect استفاده می‌کنی
    -- hl.exec_cmd("kdeconnect-indicator")

    -- اگه از برنامه خاصی استفاده می‌کنی، اینجا اضافه کن
    -- hl.exec_cmd("firefox")
end)

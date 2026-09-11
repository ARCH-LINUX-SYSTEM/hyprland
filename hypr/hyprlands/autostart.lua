-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("fcitx5 -d")          -- Bo go tieng Viet (fcitx5)
    hl.exec_cmd("caelestia shell -d") -- Caelestia shell (Quickshell)
end)

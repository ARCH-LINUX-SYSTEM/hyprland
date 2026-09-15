-- Shared variables, used by hyprlands/*.lua modules

local vars = {}

-- MY PROGRAMS
vars.terminal    = "kitty"
vars.fileManager = "dolphin"
vars.menu        = "hyprlauncher"

-- KEYBINDINGS
vars.mainMod = "SUPER" -- Sets "Windows" key as main modifier

local mainMod = vars.mainMod

-- Each entry: { key = "<bind string>", action = <hl.dsp dispatcher>, opts = <optional hl.bind opts> }
-- Consumed by hyprlands/keybinds.lua, which just loops over this list and calls hl.bind.
vars.keybinds = {
    { key = mainMod .. " + Q", action = hl.dsp.exec_cmd(vars.terminal) },
    { key = mainMod .. " + C", action = hl.dsp.window.close() },
    { key = mainMod .. " + M", action = hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'") },
    { key = mainMod .. " + E", action = hl.dsp.exec_cmd(vars.fileManager) },
    { key = mainMod .. " + V", action = hl.dsp.window.float({ action = "toggle" }) },
    { key = mainMod .. " + R", action = hl.dsp.exec_cmd(vars.menu) },
    { key = mainMod .. " + P", action = hl.dsp.window.pseudo() },
    { key = mainMod .. " + J", action = hl.dsp.layout("togglesplit") }, -- dwindle only

    -- Caelestia Shell global shortcuts (requires xdg-desktop-portal-hyprland)
    -- See README.md "Phim tat va IPC" for the full list of shortcut names.
    { key = mainMod .. " + SUPER_L", action = hl.dsp.global("caelestia:launcher"), opts = { release = true } }, -- Tap SUPER alone
    { key = mainMod .. " + SPACE",   action = hl.dsp.global("caelestia:utilities") }, -- Utilities popup (toggles, incl. wallpaper)
    { key = mainMod .. " + H",       action = hl.dsp.global("caelestia:wallpaperToggle") }, -- Toggle wallpaper on/off (was SUPER+W, moved to free up WASD for focus/swap)
    { key = mainMod .. " + SHIFT + H", action = hl.dsp.exec_cmd("caelestia wallpaper -r") }, -- Random wallpaper (was SUPER+SHIFT+W)
    { key = mainMod .. " + I",       action = hl.dsp.global("caelestia:nexus") },
    { key = mainMod .. " + E",       action = hl.dsp.global("caelestia:settings") }, -- Settings popup (giong nut Mo cai dat trong popup bar)
    { key = mainMod .. " + G",       action = hl.dsp.global("caelestia:dashboard") }, -- was SUPER+D, moved to free up WASD for focus/swap
    { key = mainMod .. " + F",       action = hl.dsp.global("caelestia:sidebar") }, -- was SUPER+A, moved to free up WASD for focus/swap
    { key = mainMod .. " + X",       action = hl.dsp.global("caelestia:session") },
    { key = mainMod .. " + L",       action = hl.dsp.global("caelestia:lock") },
    { key = mainMod .. " + T",       action = hl.dsp.global("caelestia:themeToggle") }, -- Toggle dark/light

    -- Move focus with mainMod + WASD (A=left, D=right, W=up, S=down)
    { key = mainMod .. " + A", action = hl.dsp.focus({ direction = "left" }) },
    { key = mainMod .. " + D", action = hl.dsp.focus({ direction = "right" }) },
    { key = mainMod .. " + W", action = hl.dsp.focus({ direction = "up" }) },
    { key = mainMod .. " + S", action = hl.dsp.focus({ direction = "down" }) },

    -- Swap window position with mainMod + SHIFT + WASD
    { key = mainMod .. " + SHIFT + A", action = hl.dsp.window.swap({ direction = "left" }) },
    { key = mainMod .. " + SHIFT + D", action = hl.dsp.window.swap({ direction = "right" }) },
    { key = mainMod .. " + SHIFT + W", action = hl.dsp.window.swap({ direction = "up" }) },
    { key = mainMod .. " + SHIFT + S", action = hl.dsp.window.swap({ direction = "down" }) },

    -- Example special workspace (scratchpad) -- was SUPER+S, moved to free up WASD for focus/swap
    { key = mainMod .. " + N", action = hl.dsp.workspace.toggle_special("magic") },

    -- Screenshot vung chon (giong Win+Shift+S) -- was SUPER+SHIFT+S, moved to free up WASD for focus/swap
    { key = mainMod .. " + SHIFT + N", action = hl.dsp.exec_cmd("caelestia screenshot -r slurp -f") },

    -- Quay man hinh: nhan de bat dau, nhan lai de dung (toggle)
    { key = mainMod .. " + SHIFT + R", action = hl.dsp.exec_cmd("caelestia record") },

    -- Quay 1 vung man hinh: dung slurp de chon vung truoc khi quay
    { key = mainMod .. " + ALT + R", action = hl.dsp.exec_cmd("caelestia record -r") },

    -- Scroll through existing workspaces with mainMod + scroll
    { key = mainMod .. " + mouse_down", action = hl.dsp.focus({ workspace = "e+1" }) },
    { key = mainMod .. " + mouse_up",   action = hl.dsp.focus({ workspace = "e-1" }) },

    -- Move/resize windows with mainMod + LMB/RMB and dragging
    { key = mainMod .. " + mouse:272", action = hl.dsp.window.drag(),   opts = { mouse = true } },
    { key = mainMod .. " + mouse:273", action = hl.dsp.window.resize(), opts = { mouse = true } },

    -- Screenshot (popup thong bao Open/Save sau khi chup, xem README caelestia-cli)
    { key = "Print",         action = hl.dsp.exec_cmd("caelestia screenshot") },
    { key = "SHIFT + Print", action = hl.dsp.exec_cmd("caelestia screenshot -r slurp -f") },

    -- Laptop multimedia keys for volume and LCD brightness
    { key = "XF86AudioRaiseVolume",  action = hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), opts = { locked = true, repeating = true } },
    { key = "XF86AudioLowerVolume",  action = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      opts = { locked = true, repeating = true } },
    { key = "XF86AudioMute",         action = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     opts = { locked = true, repeating = true } },
    { key = "XF86AudioMicMute",      action = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   opts = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessUp",   action = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  opts = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessDown", action = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  opts = { locked = true, repeating = true } },

    -- Requires playerctl
    { key = "XF86AudioNext",  action = hl.dsp.exec_cmd("playerctl next"),       opts = { locked = true } },
    { key = "XF86AudioPause", action = hl.dsp.exec_cmd("playerctl play-pause"), opts = { locked = true } },
    { key = "XF86AudioPlay",  action = hl.dsp.exec_cmd("playerctl play-pause"), opts = { locked = true } },
    { key = "XF86AudioPrev",  action = hl.dsp.exec_cmd("playerctl previous"),   opts = { locked = true } },
}

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    table.insert(vars.keybinds, { key = mainMod .. " + " .. key,         action = hl.dsp.focus({ workspace = i }) })
    table.insert(vars.keybinds, { key = mainMod .. " + SHIFT + " .. key, action = hl.dsp.window.move({ workspace = i }) })
end

return vars

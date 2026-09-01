---------------------
---- KEYBINDINGS ----
---------------------
-- https://wiki.hypr.land/Configuring/Basics/Binds/

---@module 'hl'

local programs = require("programs")

local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + RETURN",    hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + O",         hl.dsp.exec_cmd(programs.notes))
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd(programs.editor))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(programs.editorAlt))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(programs.menu))

-- Rofi launcher style changer
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/rofi/launchers/launcher-style-changer.sh"))

-- Web search
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/rofi/scripts/websearch.sh"))

-- Window management
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + F",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Move focus with arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move windows with SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces - mouse hangi monitördeyse oraya geç
-- Move active window to workspace with SHIFT
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,            hl.dsp.focus({ workspace = i, on_current_monitor = true }))
    hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -config ~/.config/rofi/applets/cliphist.rasi | cliphist decode | wl-copy"))

-- Wallpaper picker
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallSelect.sh"))

-- Color Picker
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(programs.colorPicker .. " | wl-copy"))

-- Screen locking
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))

-- Logout menu
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("~/.config/hypr/scripts/wlogout.sh"))

-- Toggle waybar
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd("killall waybar || waybar"))

-- Waybar theme selector
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/waybarSelect.sh"))

-- Screenshots
hl.bind("SUPER + Print",         hl.dsp.exec_cmd("grimblast save area - | swappy -f -"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("grimblast save screen - | swappy -f -"))
hl.bind("Print",                 hl.dsp.exec_cmd("grimblast save active - | swappy -f -"))

-- Volume and Media Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pamixer --default-source -m"), { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"), { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })

-- Lid: clamshell with external monitor, otherwise logind hibernates
hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("~/.config/hypr/scripts/lid.sh close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/lid.sh open"),  { locked = true })

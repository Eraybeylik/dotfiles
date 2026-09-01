-- Hyprland Lua config (0.55+)
-- https://wiki.hypr.land/Configuring/Start/

---@module 'hl'

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@180",
    position = "1920x0",
    scale    = 1,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

-- Program definitions live in programs.lua (used by keybinds.lua)

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/restore-wallpaper.sh")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("xdg-user-dirs-update")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("flameshot")
    -- Machine-local, not tracked in dotfiles; skip silently where absent
    hl.exec_cmd("[ -f ~/.local/bin/news_digest.py ] && /usr/bin/python3 ~/.local/bin/news_digest.py")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")

-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Matugen palette, regenerated on wallpaper change (matugen/colors.lua).
-- Falls back to static Catppuccin colors if not generated yet.
local haveMat, mat = pcall(require, "matugen.colors")

local function rgba(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end

local glowColors = haveMat
    and { rgba(mat.primary, "66"), rgba(mat.tertiary, "66") }
    or  { "rgba(b4befe66)", "rgba(cba6f766)" }

local shadowColors = haveMat
    and { rgba(mat.tertiary, "66"), rgba(mat.primary, "66") }
    or  { "rgba(cba6f766)", "rgba(89b4fa66)" }

local borderColors = haveMat
    and { rgba(mat.primary, "ff"), rgba(mat.secondary, "ff"), rgba(mat.tertiary, "ff") }
    or  { "rgba(b4befeff)", "rgba(89b4faff)", "rgba(cba6f7ff)" }

local borderInactive = haveMat
    and rgba(mat.surface_container_high, "99")
    or  "rgba(1e1e2e99)"

hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 12,
        border_size = 2,

        col = {
            active_border   = { colors = borderColors, angle = 45 },
            inactive_border = borderInactive,
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 12,
        rounding_power = 3, -- squircle corners

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled        = true,
            range          = 20,
            render_power   = 3,
            color          = { colors = shadowColors, angle = 45 },
            color_inactive = 0x4D000000, -- rgba(0,0,0,0.3)
        },

        glow = {
            enabled        = true,
            range          = 14,
            render_power   = 3,
            color          = { colors = glowColors, angle = 45 },
            color_inactive = 0x2E1E1E2E, -- subtle dark
        },

        motion_blur = {
            enabled = true,
            samples = 7,
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            xray              = false,
            noise             = 0.02,
            contrast          = 1.1,
            brightness        = 1.0,
            vibrancy          = 0.2,
            vibrancy_darkness = 0.0,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("overshot",   { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05}  } })
hl.curve("smooth",     { type = "bezier", points = { {0.5, 0},     {0.99, 0.99} } })
hl.curve("snapback",   { type = "bezier", points = { {0.54, 0.42}, {0.01, 1.34} } })
hl.curve("curve",      { type = "bezier", points = { {0.27, 0.7},  {0.03, 0.99} } })
hl.curve("menu_decel", { type = "bezier", points = { {0.05, 0.82}, {0, 1}       } })
hl.curve("menu_accel", { type = "bezier", points = { {0.20, 0},    {0.82, 0.10} } })
hl.curve("md3_decel",  { type = "bezier", points = { {0.05, 0.80}, {0.10, 0.97} } })
hl.curve("md3_accel",  { type = "bezier", points = { {0.20, 0},    {0.80, 0.08} } })
hl.curve("linear",     { type = "bezier", points = { {0, 0},       {1, 1}       } })

hl.animation({ leaf = "windows",          enabled = true, speed = 5,   bezier = "overshot",   style = "slide" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 5,   bezier = "snapback",   style = "slide" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 5,   bezier = "snapback",   style = "slide" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 5,   bezier = "snapback",   style = "slide" })
hl.animation({ leaf = "layers",           enabled = true, speed = 5,   bezier = "overshot",   style = "slide" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 1.8, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.5, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 1.6, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.8, bezier = "menu_accel" })
hl.animation({ leaf = "border",           enabled = true, speed = 5,   bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 1.8, bezier = "md3_decel" })
hl.animation({ leaf = "fadeDim",          enabled = true, speed = 5,   bezier = "default" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 6,   bezier = "curve" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.3, bezier = "md3_decel", style = "slidefadevert 15%" })
hl.animation({ leaf = "shadowangle",      enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "glowangle",        enabled = true, speed = 100, bezier = "linear", style = "loop" })

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 0,
    },

    cursor = {
        no_hardware_cursors = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "tr",
        follow_mouse = 1,
        sensitivity  = 0.5,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name        = "compx-nearlink-mouse-dongle-1",
    sensitivity = -0.5,
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.config({
    gestures = {
        workspace_swipe_distance           = 1200, -- higher = more finger travel per workspace
        workspace_swipe_min_speed_to_force = 60,   -- higher = quick flicks don't insta-switch
        workspace_swipe_cancel_ratio       = 0.6,  -- must swipe 60% of distance to commit
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

require("keybinds")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Float rules
local floatMatches = {
    { name = "float-jome",         title = "^(jome)$" },
    { name = "float-kvantum",      class = "^(kvantummanager)$" },
    { name = "float-qt5ct",        class = "^(qt5ct)$" },
    { name = "float-qt6ct",        class = "^(qt6ct)$" },
    { name = "float-nwg-look",     class = "^(nwg-look)$" },
    { name = "float-ark",          class = "^(org\\.kde\\.ark)$" },
    { name = "float-pavucontrol",  class = "^(pavucontrol)$" },
    { name = "float-blueman",      class = "^(blueman-manager)$" },
    { name = "float-nm-applet",    class = "^(nm-applet)$" },
    { name = "float-nm-editor",    class = "^(nm-connection-editor)$" },
    { name = "float-polkit",       class = "^(org\\.kde\\.polkit-kde-authentication-agent-1)$" },
}

for _, m in ipairs(floatMatches) do
    hl.window_rule({
        name  = m.name,
        match = { class = m.class, title = m.title },
        float = true,
    })
end

-- Opacity rules
local opacityRules = {
    { name = "opacity-thorium",  class = "^(Thorium-browser)$",       opacity = "0.90 0.90" },
    { name = "opacity-opencode", class = "^(OpenCode)$",              opacity = "0.80 0.80" },
    { name = "opacity-arduino",  class = "^(Arduino IDE)$",           opacity = "0.80 0.80" },
    { name = "opacity-warp",     class = "^(dev\\.warp\\.Warp)$",     opacity = "0.80 0.80" },
    { name = "opacity-obsidian", class = "^(obsidian)$",              opacity = "0.80 0.80" },
    { name = "opacity-kitty",    class = "^(kitty)$",                 opacity = "0.80 0.80" },
    { name = "opacity-nautilus", class = "^(org\\.gnome\\.Nautilus)$", opacity = "0.80 0.80" },
    { name = "opacity-ark",      class = "^(org\\.kde\\.ark)$",       opacity = "0.80 0.80" },
}

for _, r in ipairs(opacityRules) do
    hl.window_rule({
        name    = r.name,
        match   = { class = r.class },
        opacity = r.opacity,
    })
end

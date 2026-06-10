-- ~/.config/hypr/hyprland.lua

-- Define variables up top
local terminal = "kitty"
local fileManager = "kitty -e yazi"
local mainMod = "SUPER"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- Replaces old 'env = ...'
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Set Cursor Size and Theme
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")

hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")

-- Environment Variables for GTK/Qt
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

------------------
---- MONITORS ----
------------------
hl.monitor({
    output = "",
    mode = "1920x1080@144",
    position = "auto",
    scale = "1"
})

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function ()
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("xhost +SI:localuser:root") --This for sudo gui stuff, dont remove plz
    hl.exec_cmd("histuid")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("gsr-ui")
    hl.exec_cmd("brightnessctl -d 'platform::micmute' set $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && echo 1 || echo 0)")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    hl.exec_cmd("sudo /home/yourusername/.local/bin/powerdog.sh")
end)

-----------------
---- CONFIG  ----
-----------------
-- Most standard variables are defined through `hl.config()`
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,

        -- Keys with dots in Lua must be wrapped in brackets
        ["col.active_border"] = "rgba(33ccffee)", "rgba(00ff99ee)", "45deg",
        ["col.inactive_border"] = "rgba(595959aa)",

        resize_on_border = false,
        allow_tearing = false,
        layout = "scrolling"
    },

    dwindle = {
        preserve_split = true,
    },

    scrolling = {
        direction = "right",
        column_width = 0.5,
        fullscreen_on_one_column = true,
        wrap_focus = false,
        wrap_swapcol = false,
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0"
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696
        }
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        focus_on_activate = true
    },

    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false
        }
    },

    device = {
        {
            name = "epic-mouse-v1",
            sensitivity = -0.5
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- 1. Enable animations globally
hl.config({
    animations = {
        enabled = true
    }
})

-- 2. Define Bezier curves using hl.curve()
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })
hl.curve("overshot", { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1} } })

-- 3. Declare animations using hl.animation()
hl.animation({ leaf = "global",           enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",           enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 3.8,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesIn",     enabled = true, speed = 3.8,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesOut",    enabled = true, speed = 3.8,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",       enabled = true, speed = 7,    bezier = "quick" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "overshot" })

hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 5,
    bezier = "overshot",
    style = "slidefadevert -100%"
})

-- This dims and blurs your active windows when a special workspace is open
hl.config({
    decoration = {
        dim_special = 0.5, -- Range 0.0 to 1.0 (0.5 is a nice cinematic dim)
        blur = {
            special = true -- Applies blur to the background
        }
    }
})

---------------------
---- KEYBINDINGS ----
---------------------
-- Base binds (Uses hl.bind and dispatches actions internally)
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Move focus across the horizontal ribbon
hl.bind("SUPER + left",  hl.dsp.layout("focus l"))
hl.bind("SUPER + right", hl.dsp.layout("focus r"))
hl.bind("SUPER + up",    hl.dsp.layout("focus u"))
hl.bind("SUPER + down",  hl.dsp.layout("focus d"))

-- Switch workspaces (Kept traditional, no vertical stacking)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Replace your old SUPER + T line with these:

-- 1. Cycle Width Presets (33% -> 50% -> 66% -> 100% width)
hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))
hl.bind("SHIFT + mouse:275", hl.dsp.layout("colresize -conf"))
hl.bind("SHIFT + mouse:276", hl.dsp.layout("colresize +conf"))

-- 2. Maximize / Fit Expand (Instantly blows the window up to fill 100% of the screen)
hl.bind(mainMod .. " + T", hl.dsp.layout("fit expand"))

-- 3. Equalize Columns (If things get messy, snap all visible windows to equal width)
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.layout("fit visible"))

-- Special Workspaces
-- FIXED: Added defensive nil checking to prevent scrolling layout crashes
local function is_open(class)
    local windows = hl.get_windows()
    if not windows then return false end

    for _, w in ipairs(windows) do
        if w and w.class and string.lower(w.class) == string.lower(class) then
            return true
        end
    end
    return false
end

-- --- Dash (Zellij) ---
hl.bind(mainMod .. " + Space", function()
    if not is_open("scratch-dash") then
        hl.dispatch(hl.dsp.exec_cmd("kitty --app-id scratch-dash zellij --layout dashboard", {
            workspace = "special:dash"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("dash"))
end)

-- --- Files (Yazi) ---
hl.bind(mainMod .. " + E", function()
    if not is_open("scratch-yazi") then
        hl.dispatch(hl.dsp.exec_cmd("kitty --app-id scratch-yazi yazi", {
            workspace = "special:files"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("files"))
end)

-- --- Terminal (Kitty) ---
hl.bind(mainMod .. " + X", function()
    if not is_open("scratch-term") then
        hl.dispatch(hl.dsp.exec_cmd("kitty --app-id scratch-term", {
            workspace = "special:term"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("term"))
end)

-- --- Browser (Vivaldi) ---
hl.bind(mainMod .. " + B", function()
    if not is_open("vivaldi-stable") then
        hl.dispatch(hl.dsp.exec_cmd("vivaldi-stable", {
            workspace = "special:browser"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("browser"))
end)

-- --- Games (Steam) ---
hl.bind(mainMod .. " + G", function()
    if not is_open("steam") then
        hl.dispatch(hl.dsp.exec_cmd("steam", {
            workspace = "special:games"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("games"))
end)

-- --- Pad (The "Normal" Way) ---
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("pad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:pad" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.layout("focus r"))
hl.bind("mouse:276", hl.dsp.layout("focus l"))
hl.bind("mouse:275", hl.dsp.layout("focus r"))

hl.bind("SUPER + ALT + mouse_down", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + ALT + mouse_up",   hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + mouse:276", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + mouse:275", hl.dsp.layout("swapcol r"))

-- Mouse actions
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia Keys
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { repeating = true, locked = true })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { repeating = true, locked = true })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
    { repeating = true, locked = true })

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("swayosd-client --brightness raise"),
    { repeating = true, locked = true })

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { repeating = true, locked = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),   { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),   { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Vicinae bindings
hl.bind("ALT + Space",     hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + V",       hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind("ALT + TAB",       hl.dsp.exec_cmd("vicinae vicinae://launch/wm/switch-windows"))
hl.bind("SUPER + PERIOD",  hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"))
hl.bind("SUPER + W",       hl.dsp.exec_cmd("vicinae vicinae://launch/@sovereign/store.vicinae.awww-switcher/wpgrid"))
hl.bind("ALT + E",         hl.dsp.exec_cmd("vicinae vicinae://launch/files/search"))

-- Hyprshot
hl.bind("Print",         hl.dsp.exec_cmd("hyprshot -m region --clipboard-only -z"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region -z"))
hl.bind("CONTROL + Print",       hl.dsp.exec_cmd("hyprshot -m output --clipboard-only -z"))
hl.bind("CONTROL + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output -z"))

-- wleave
hl.bind(mainMod .. " + L", function()
    local handle = io.popen("pgrep -x wleave")
    local result = handle:read("*a")
    handle:close()

    if result ~= "" then
        hl.exec_cmd("pkill -x wleave")
    else
        hl.exec_cmd("wleave -x -k ")
    end
end, { locked = true })

-- --- GPU Screen Recorder Overlay ---
hl.bind("ALT + Z", hl.dsp.exec_cmd("gpu-screen-recorder-ui"))

-- ASUS stuff
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd([[notify-send  "mf do you really use this"]]))

-- Fn9: Mic (Code 530)
hl.bind("XF86AudioMicMute", function()
    hl.dispatch(hl.dsp.exec_cmd([[
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && \
        sleep 0.04 && \
        brightnessctl -d 'platform::micmute' set $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && echo 1 || echo 0) && \
        (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && swayosd-client --custom-message "🎤 MUTED" || swayosd-client --custom-message "🎤 ON")
    ]]))
end)

-- Fn10: Camera LED (Code 212)
hl.bind("XF86WebCam", hl.dsp.exec_cmd([[notify-send  "Use physical shutter"]]))

--------------------------------
---- WINDOW AND LAYER RULES ----
--------------------------------
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize"
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true
})

hl.layer_rule({
    name = "vicinae-blur",
    match = { namespace = "vicinae" },
    blur = true,
    ignore_alpha = 0
})

hl.layer_rule({
    name = "vicinae-no-animation",
    match = { namespace = "vicinae" },
    no_anim = true
})

-- Smart Gaps templates - Left commented for your reference
-- hl.windowrule({
--     name = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding = 0
-- })
-- hl.windowrule({
--     name = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding = 0
-- })

-- Zed always opens on workspace 1
hl.window_rule({
    match = {
        class = "dev.zed.Zed"
    },
    workspace = "1"
})

-- Oculante floating, centered, pinned
hl.window_rule({
    match = {
        class = "oculante"
    },
    float = true,
    center = true,
    pin = true
})

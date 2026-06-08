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
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

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
    mode = "1920x1080@60",
    position = "auto",
    scale = "1"
})

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function ()
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("swayosd-server &")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("histuid")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("bw serve")
    hl.exec_cmd("gsr-ui")
    hl.exec_cmd("~/.local/share/deckboard/deckboard-3.2.0/deckboard --minimized")
    hl.exec_cmd("brightnessctl -d 'platform::micmute' set $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && echo 1 || echo 0)")
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
        layout = "dwindle"
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    scrolling = {
        fullscreen_on_one_column = true,
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

    animations = {
        enabled = true, -- Replaces 'yes, please :)'
        bezier = {
            "easeOutQuint,   0.23, 1,    0.32, 1",
            "easeInOutCubic, 0.65, 0.05, 0.36, 1",
            "linear,         0,    0,    1,    1",
            "almostLinear,   0.5,  0.5,  0.75, 1",
            "quick,          0.15, 0,    0.1,  1"
        },
        animation = {
            "global,        1,     10,    default",
            "border,        1,     5.39,  easeOutQuint",
            "windows,       1,     4.79,  easeOutQuint",
            "windowsIn,     1,     4.1,   easeOutQuint, popin 87%",
            "windowsOut,    1,     1.49,  linear,       popin 87%",
            "fadeIn,        1,     1.73,  almostLinear",
            "fadeOut,       1,     1.46,  almostLinear",
            "fade,          1,     3.03,  quick",
            "layers,        1,     3.81,  easeOutQuint",
            "layersIn,      1,     4,     easeOutQuint, fade",
            "layersOut,     1,     1.5,   linear,       fade",
            "fadeLayersIn,  1,     1.79,  almostLinear",
            "fadeLayersOut, 1,     1.39,  almostLinear",
            "workspaces,    1,     1.94,  almostLinear, fade",
            "workspacesIn,  1,     1.21,  almostLinear, fade",
            "workspacesOut, 1,     1.94,  almostLinear, fade",
            "zoomFactor,    1,     7,     quick",
            "specialWorkspace, 1,     4,     easeOutQuint, slidevert"
        }
    },



    master = {
        new_status = "master"
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

---------------------
---- KEYBINDINGS ----
---------------------
-- Base binds (Uses hl.bind and dispatches actions internally)
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))

-- Move focus
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces (Look how easy this is in Lua!)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special Workspaces
-- Helper function to check if a window class is currently open
local function is_open(class)
    for _, w in ipairs(hl.get_windows()) do
        if w.class == class then return true end
    end
    return false
end

-- --- Dash (Zellij) ---
-- Logic: If it doesn't exist, launch it. Then toggle the workspace.
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
-- --- Browser (Vivaldi) ---
hl.bind(mainMod .. " + B", function()
    -- Must be strictly lowercase to match what hyprctl outputs
    if not is_open("vivaldi-stable") then
        hl.dispatch(hl.dsp.exec_cmd("vivaldi-stable", {
            workspace = "special:browser"
        }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("browser"))
end)

-- --- Pad (The "Normal" Way) ---
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("pad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:pad" }))

-- Scroll Workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

-- Mouse actions: bindm is replaced by { mou 32se = true } flag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia Keys: bindel -> { repeating = true, locked = true } | bindl -> { locked = true }
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

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Vicinae bindings
hl.bind("ALT + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("vicinae vicinae://launch/wm/switch-windows"))
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("vicinae vicinae://launch/@sovereign/store.vicinae.awww-switcher/wpgrid"))
hl.bind("ALT + E", hl.dsp.exec_cmd("vicinae vicinae://launch/files/search"))
hl.bind(mainMod .." + G", hl.dsp.exec_cmd("xdg-open 'vicinae://launch/@KevinBatdorf/store.raycast.steam/steam'"))

-- Hyprshot
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CONTROL + Print", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind("CONTROL + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output"))


-- wleave
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("wleave"))

-- --- GPU Screen Recorder Overlay ---
hl.bind("ALT + Z", hl.dsp.exec_cmd("gpu-screen-recorder-ui"))

-- ASUS stuff


-- Fn6: Touchpad (Code 530)
hl.bind("XF86AudioMicMute", function()
    -- 1. Fire the toggle instantly
    hl.dispatch(hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

    -- 2. Pause a tiny fraction of a second for PipeWire to breathe, then sync LED
    hl.dispatch(hl.dsp.exec_cmd("sleep 0.05 && brightnessctl -d 'platform::micmute' set $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED' && echo 1 || echo 0)"))

    hl.dispatch(hl.dsp.exec_cmd([[
            if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q 'MUTED'; then
                swayosd-client --custom-message "🎤 MUTED"
            else
                swayosd-client --custom-message "🎤 ON"
            fi
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

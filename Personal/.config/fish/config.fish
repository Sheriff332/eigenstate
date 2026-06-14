source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

set -gx TERMINAL kitty
set -gx EDITOR zeditor

### --- FZF CONFIGURATION --- ###

# 1. Initialize fzf integration (Enables Ctrl+R, Ctrl+T, and Alt+C)
fzf --fish | source

# 2. Make Ctrl+T search your entire HOME directory (all your folders)
# We use 'find ~' so it sees everything you own, regardless of where you are.
# '2>/dev/null' hides "Permission Denied" errors from system folders.
# set -ux FZF_CTRL_T_COMMAND "find ~ -type f 2>/dev/null"

# 3. Make Alt+C (Change Directory) search all folders in HOME
# set -ux FZF_ALT_C_COMMAND "find ~ -type d 2>/dev/null"

# 4. UI Customization (Optional but looks great)
# --height 40%: Don't take up the whole screen
# --layout=reverse: Put the search bar at the top
# --border: Add a nice frame around the finder
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline"

# 5. Advanced: Using 'fd' for speed
set -gx FZF_CTRL_T_COMMAND "fd --type f --hidden --exclude .git --base-directory ~"
set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --exclude .git --base-directory ~"

### --- END FZF CONFIG --- ###

alias c 'zeditor'
alias cls 'clear && fastfetch'
alias weather 'rustormy -m full -c'
alias youtube 'youtube-tui'

function toohot!
    # 1. Kill Boost immediately
    echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null

    # 2. Get the active profile
    # We use awk to grab the 3rd word from the line "Active profile: Balanced"
    set -l cur (asusctl profile get | awk '/Active profile:/ {print $3}')

    switch $cur
        case Performance
            asusctl profile set Balanced
            swayosd-client --custom-message "Cooling Down: Balanced"
        case Balanced
            asusctl profile set Quiet
            swayosd-client --custom-message "Cooling Down: Quiet"
        case Quiet
            swayosd-client --custom-message "you're cooked lil bro (At Min)"
    end
end

function overclock
    # Get current active profile
    set -l cur (asusctl profile get | awk '/Active profile:/ {print $3}')

    switch $cur
        case Quiet
            asusctl profile set Balanced
            swayosd-client --custom-message "Profile: Balanced"
        case Balanced
            # Set hardware to Performance but keep software Boost OFF
            asusctl profile set Performance
            echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null
            swayosd-client --custom-message "Performance: Boost OFF (Safe Speed)"
        case Performance
            # THE NUCLEAR OPTION
            echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null
            swayosd-client --custom-message "laptop commited die (Boost ON)"
    end
end

function diskard
    read -l -P "Empty trash? [y/N] " ans
    if test "$ans" = "y"
        rm -rf ~/.local/share/Trash/{files,info}/*
        echo "Trash emptied."
    else
        echo "Canceled."
    end
end


starship init fish | source

zoxide init fish | source

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

starship init fish | source

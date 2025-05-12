
#!/bin/bash
# Vars
    STYLE_DIR="$HOME/.config/waybar/styles"
    MAIN_STYLE="$HOME/.config/waybar/style.css"
# Change Mode
    selected_mode=$(echo -e "S-Corner-Light\nS-Corner-Dark" | rofi -dmenu -config "$HOME/.config/rofi/hyprmode.rasi" -p "WaybarMode:")
    [[ -z "$selected_mode" ]] && exit 0
    STYLE_FILE="$STYLE_DIR/${selected_mode,,}.css"
    if [[ ! -f "$STYLE_FILE" ]]; then
        notify-send "Waybar" "Style not found: $STYLE_FILE"
        exit 1
    fi
    cp "$STYLE_FILE" "$MAIN_STYLE"
    case "$selected_mode" in
        S-Corner-Light)
        wal -R
            bash ~/.config/kitty/scripts/s-corner-light.css
            ;;
        S-Corner-Dark)
        wal -R
            bash ~/.config/kitty/scripts/s-corner-dark.css
            ;;
    esac
    notify-send "WaybarMode" "Switched to $selected_mode style"

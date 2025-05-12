#!/bin/bash
# Vars
    STYLE_DIR="$HOME/.config/waybar/styles"
    MAIN_STYLE="$HOME/.config/waybar/style.css"
# Change Mode
    selected_mode=$(echo -e "walbar-dark\nwalbar-light\ndark\nlight\ns-corner-dark\ns-corner-light\ns-corner-light2\ns-corner-dark2" | rofi -dmenu -config "$HOME/.config/rofi/hyprmode.rasi" -p "WaybarMode:")
    [[ -z "$selected_mode" ]] && exit 0

    STYLE_FILE="$STYLE_DIR/${selected_mode,,}.css"

    if [[ ! -f "$STYLE_FILE" ]]; then
        notify-send "Waybar" "Style not found: $STYLE_FILE"
        exit 1
    fi

    cp "$STYLE_FILE" "$MAIN_STYLE"

    case "$selected_mode" in
        dark|walbar-dark)
            bash ~/.config/kitty/scripts/kitty-dark-pywal.sh
            ;;
        light|walbar-light)
            bash ~/.config/kitty/scripts/kitty-light-pywal.sh
            ;;
        s-corner-light)
            bash ~/.config/kitty/scripts/kitty-light-pywal.sh
            ;;
        s-corner-dark)
            bash ~/.config/kitty/scripts/kitty-dark-pywal.sh
            ;;
        s-corner-dark2)
            bash ~/.config/kitty/scripts/kitty-dark-pywal2.sh
            ;;
        s-corner-light2)
            bash ~/.config/kitty/scripts/kitty-light-pywal2.sh
            ;;
    esac
    notify-send "WaybarMode" "Switched to $selected_mode style"
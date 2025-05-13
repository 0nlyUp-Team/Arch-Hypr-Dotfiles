#!/bin/bash
STYLES_DIR="$HOME/.config/waybar/styles"
CONFIGS_DIR="$HOME/.config/waybar/configs"
THEMES=($(ls "$STYLES_DIR"/*.css | xargs -n1 basename))
SELECTED=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -p "Выберите тему Waybar" -config "$HOME/.config/rofi/hyprmode.rasi")
[ -z "$SELECTED" ] && exit 1
BASENAME="${SELECTED%.css}"
CONFIG_FILE="$CONFIGS_DIR/$BASENAME.jsonc"
STYLE_FILE="$STYLES_DIR/$SELECTED"
if [ ! -f "$CONFIG_FILE" ]; then
  notify-send -t 5000 -u critical -i dialog-error "Error:" "$SELECTED Config Not Found. "
  exit 1
fi
case "$BASENAME" in
    arch)
        bash ~/.config/kitty/scripts/kitty-dark-pywal.sh
      ;;
    arch2)
        bash ~/.config/kitty/scripts/kitty-light-pywal2.sh
      ;;
esac
pkill waybar
notify-send -t 5000 -i dialog-information "Sucess" "$SELECTED Applyed Sucessfully!"
# Debug
  notify-send -t 5000 -i dialog-warning "Debug" "Style File: $STYLE_FILE"
  notify-send -t 5000 -i dialog-warning "Debug" "Config File: $CONFIG_FILE"
# Debug End
waybar -s "$STYLE_FILE" -c "$CONFIG_FILE" &

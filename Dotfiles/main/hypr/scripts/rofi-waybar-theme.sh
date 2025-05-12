#!/bin/bash

STYLES_DIR="$HOME/.config/waybar/styles"
CONFIGS_DIR="$HOME/.config/waybar/configs"

# Список тем (файлы .css)
THEMES=($(ls "$STYLES_DIR"/*.css | xargs -n1 basename))

# Выбор темы через rofi
SELECTED=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -p "Выберите тему Waybar" -config "$HOME/.config/rofi/hyprmode.rasi")
[ -z "$SELECTED" ] && exit 1

# Удаляем расширение .css
BASENAME="${SELECTED%.css}"

# Проверяем, существует ли конфиг с тем же именем
CONFIG_FILE="$CONFIGS_DIR/$BASENAME.jsonc"
STYLE_FILE="$STYLES_DIR/$SELECTED"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "[!] Конфиг $CONFIG_FILE не найден."
  exit 1
fi

# Перезапуск waybar с выбранными конфигом и стилем
pkill waybar
notify-send "$STYLE_FILE"
notify-send "$CONFIG_FILE"
waybar -s "$STYLE_FILE" -c "$CONFIG_FILE" &

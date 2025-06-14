#!/bin/bash

# === Конфигурация ===
WALLPAPERS_DIR="$HOME/Wallpapers"
THUMB_CACHE="$HOME/.cache/rofi_wallpaper_thumbnails"
LAST_WALLPAPER_FILE="$HOME/.cache/last_wallpaper.txt"

mkdir -p "$THUMB_CACHE"

# === Функции ===

safe_kill() {
    local proc_name="$1"
    pkill -TERM "$proc_name"
    local timeout=5  # максимум 5 секунд ждать завершения

    while pgrep "$proc_name" >/dev/null && [ $timeout -gt 0 ]; do
        sleep 0.2
        timeout=$((timeout - 1))
    done

    if pgrep "$proc_name" >/dev/null; then
        notify-send -t 3000 -u normal "Warning: $proc_name still running"
        # Можно принудительно убить:
        pkill -KILL "$proc_name"
    fi
}

generate_rofi_data() {
    local data_file=$1
    cd "$WALLPAPERS_DIR" || exit 1
    while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        if [[ "$filename" == *.mp4 || "$filename" == *.MP4 ]]; then
            thumb="$THUMB_CACHE/${filename}.png"
            [ ! -f "$thumb" ] && ffmpeg -i "$file" -ss 00:00:01 -vframes 1 -vf "scale=200:-1" "$thumb" 2>/dev/null
            icon="$thumb"
        else
            icon="$file"
        fi
        echo -en "$filename\0Icon\x1f$icon\n"
    done < <(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.png" -o -iname "*.mp4" -o -iname "*.gif" \) -print0) > "$data_file"
}

apply_wallpaper() {
    local selected="$1"
    local full_path="$HOME/Wallpapers/$selected"
    echo "$full_path" > "$HOME/.cache/last_wallpaper.txt"

    if [[ "$selected" == *.mp4 || "$selected" == *.MP4 ]]; then
        #notify-send "Applying Video Wallpaper:" "$selected"
        notify-send -t 5000 -u low -i dialog-information "Sucess Applying Wallpaper:" "$full_path"
        safe_kill swww-daemon
        safe_kill mpvpaper
        pkill swww
        local output=$(hyprctl monitors | awk '/Monitor/ {print $2; exit}')
        mpvpaper -o "--loop --no-audio" "$output" "$full_path" &
        wal -i "$full_path" --backend Colorz
    else
       #notify-send "Applying Static Wallpaper:" "$selected"
        notify-send -t 5000 -u low -i dialog-information "Sucess Applying Wallpaper:" "$full_path"
        safe_kill mpvpaper
        safe_kill swww-daemon
        swww-daemon &
        swww img "$full_path"
        wal -i "$full_path" --backend Wal
    fi

    # Apply Color Themes
    "$HOME/.config/walgen/walgen.sh" "cava" "$HOME/.config/cava/config"
    "$HOME/.config/walgen/walgen.sh" "rofi-dmenu" "$HOME/.config/rofi/themes/rofi-dmenu-theme.rasi"
    "$HOME/.config/walgen/walgen.sh" "rofi-run" "$HOME/.config/rofi/themes/rofi-run-theme.rasi"
    "$HOME/.config/walgen/walgen.sh" "hyprland-colors" "$HOME/.config/hypr/conf/colors.conf"
    hyprctl reload
}

# === Главная функция ===
main() {
    local data_file=$(mktemp)
    generate_rofi_data "$data_file"
    local selected=$(cat "$data_file" | rofi -dmenu -config "$HOME/.config/rofi/wallpaper.rasi" -p "Select Wallpaper: ")
    rm "$data_file"
    [ -z "$selected" ] && exit 0
    apply_wallpaper "$selected"
}

# === Авто-применение последнего обоя ===
auto_apply_last_wallpaper() {
    if [ ! -f "$LAST_WALLPAPER_FILE" ]; then
        echo "No last wallpaper found."
        return
    fi

    if pgrep -x mpvpaper >/dev/null || pgrep -x swww >/dev/null || pgrep -x swww-daemon >/dev/null; then
        echo "Wallpaper already running (mpvpaper or swww). Skipping restore."
        return
    fi

    local last_wallpaper
    last_wallpaper=$(cat "$LAST_WALLPAPER_FILE")
    if [ -f "$last_wallpaper" ]; then
        apply_wallpaper "$(basename "$last_wallpaper")"
    else
        notify-send -t 3000 -u normal -i dialog-warning "Warning" "Saved wallpaper not found: $last_wallpaper"
    fi
}

# === Точка входа ===
if [[ "$1" == "--restore" ]]; then
    auto_apply_last_wallpaper
elif [[ "$1" == "--select" ]]; then
    main
else
    echo "Usage: $0 [--restore|--select]"
    exit 1
fi

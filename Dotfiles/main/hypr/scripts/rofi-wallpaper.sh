#!/bin/bash

# === Конфигурация ===
WALLPAPERS_DIR="$HOME/Wallpapers"
THUMB_CACHE="$HOME/.cache/rofi_wallpaper_thumbnails"
LAST_WALLPAPER_FILE="$HOME/.cache/last_wallpaper.txt"

mkdir -p "$THUMB_CACHE"

# === Функции ===

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
        pkill swww-daemon
        pkill mpvpaper
        local output=$(hyprctl monitors | awk '/Monitor/ {print $2; exit}')
        mpvpaper -o "--loop --no-audio" "$output" "$full_path" &
        wal -i "$full_path" --backend Colorz
    else
       #notify-send "Applying Static Wallpaper:" "$selected"
        notify-send -t 5000 -u low -i dialog-information "Sucess Applying Wallpaper:" "$full_path"
        pkill mpvpaper
        pkill swww-daemon
        swww-daemon &
        swww img "$full_path" --transition-type none
        wal -i "$full_path" --backend Wal
    fi

    generate_theme "rofi-dmenu" "$HOME/.config/rofi/themes/rofi-dmenu-theme.rasi"
    generate_theme "rofi-run" "$HOME/.config/rofi/themes/rofi-run-theme.rasi"
    generate_theme "hyprland-colors" "$HOME/.config/hypr/conf/colors.conf"

    hyprctl reload
}

generate_theme() {
    local template_name="$1"
    local output_file="$2"
    local template_path="$HOME/.config/walgen/templates/${template_name}.txt"

    if [ ! -f "$HOME/.cache/wal/colors" ]; then
        notify-send -t 5000 -u critical -i dialog-error "Error (Caused by rofi-wallpaper.sh)" "File Not Found: $HOME/.cache/wal/colors"
        return 1
    fi

    if [ ! -f "$template_path" ]; then
        notify-send -t 5000 -u critical -i dialog-error "Error (Caused by rofi-wallpaper.sh)" "Template Not Found: $template_path"
        return 1
    fi

    mkdir -p "$(dirname "$output_file")"

    local -a colors
    mapfile -t colors < "$HOME/.cache/wal/colors"

    local -A template_vars=(
        ["background"]="${colors[0]}"
        ["foreground"]="${colors[7]}"
        ["accent"]="${colors[3]}"
        ["text"]="${colors[15]}"
        ["black"]="${colors[0]}"
        ["white"]="${colors[15]}"
    )

    for i in {0..15}; do
        hex="${colors[$i]#"#"}"
        r=$((16#${hex:0:2}))
        g=$((16#${hex:2:2}))
        b=$((16#${hex:4:2}))
        template_vars["color$i"]="${colors[$i]}"
        template_vars["rgba_color$i"]="rgba($r, $g, $b, 1.0)"
    done

    local content
    content=$(<"$template_path")

    # Подстановка обычных переменных
    for key in "${!template_vars[@]}"; do
        content=${content//"{{$key}}"/"${template_vars[$key]}"}
    done

    # Обработка {{rgba_colorX,A}}
    if grep -q '{{rgba_color[0-9]\{1,2\},[0-9.]\+}}' <<< "$content"; then
        matches=$(grep -oP '{{rgba_color[0-9]{1,2},[0-9.]+}}' <<< "$content" | sort -u)
        for match in $matches; do
            index=$(echo "$match" | grep -oP 'rgba_color\K[0-9]+')
            alpha=$(echo "$match" | grep -oP ',\K[0-9.]+')
            hex="${colors[$index]#"#"}"
            r=$((16#${hex:0:2}))
            g=$((16#${hex:2:2}))
            b=$((16#${hex:4:2}))
            rgba="rgba($r, $g, $b, $alpha)"
            content="${content//$match/$rgba}"
        done
    fi

    if [[ "$template_name" == "hyprland-colors" ]]; then
        [[ -f "$HOME/.cache/wal/colors" ]] || { notify-send -u critical "Missing" "$HOME/.cache/wal/colors"; return 1; }
        mapfile -t colors < "$HOME/.cache/wal/colors"
        > "$HOME/.config/hypr/conf/colors.conf"
        for i in {0..15}; do
            printf "\$color%d = 0xff%s\n" $((i+1)) "${colors[$i]#\#}" >> "$HOME/.config/hypr/conf/colors.conf"
        done
        notify-send -t 5000 -u normal -i dialog-warning "Debug (Caused by rofi-wallpaper.sh)" "Hyprland Colors Generated: $HOME/.config/hypr/conf/colors.conf"
        return 0
    fi

    echo "$content" > "$output_file"
    notify-send -t 3000 -u low -i dialog-information "Theme Generated" "$output_file"
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
    [ -f "$HOME/.cache/last_wallpaper.txt" ] && apply_wallpaper "$(basename "$(cat "$HOME/.cache/last_wallpaper.txt")")"
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

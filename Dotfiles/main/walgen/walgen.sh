#!/bin/bash

TEMPLATES_DIR="$HOME/.config/walgen/templates"
PYWAL_COLORS="$HOME/.cache/wal/colors"

generate_theme() {
    local template_name="$1"
    local output_file="$2"
    
    if [ ! -f "$PYWAL_COLORS" ]; then
	notify-send -t 5000 -u critical -i dialog-error "Error:" "File Not Found: $PYWAL_COLORS"
        return 1
    fi

    local template_path="${TEMPLATES_DIR}/${template_name}.txt"
    if [ ! -f "$template_path" ]; then
	notify-send -t 5000 -u critical -i dialog-error "Error:" "Template Not Found in: $TEMPLATES_DIR"
        return 1
    fi

    mkdir -p "$(dirname "$output_file")"

    local -a colors
    mapfile -t colors < "$PYWAL_COLORS"

    local -A template_vars=(
        ["background"]="${colors[0]}"
        ["foreground"]="${colors[7]}"
        ["accent"]="${colors[3]}"
        ["text"]="${colors[15]}"
        ["black"]="${colors[0]}"
        ["white"]="${colors[15]}"
    )

    for i in {0..15}; do
        template_vars["color$i"]="${colors[$i]}"
    done

    local content
    content=$(<"$template_path")

    for key in "${!template_vars[@]}"; do
        content=${content//"{{$key}}"/"${template_vars[$key]}"}
    done

    echo "$content" > "$output_file"
    notify-send -t 5000 -u low -i dialog-information "Sucess:" "Theme Generated: $output_file"
}

# Пример использования:
generate_theme "rofi" "$HOME/.config/rofi/themes/my-theme.rasi"
generate_theme "hyprland" "$HOME/.config/hypr/colors.conf"
#!/bin/bash

TEMPLATES_DIR="$HOME/.config/walgen/templates"
PYWAL_COLORS="$HOME/.cache/wal/colors"

generate_theme() {
    local tpl_name="$1"
    local out_file="$2"
    local tpl="${TEMPLATES_DIR}/${tpl_name}.txt"

    [[ -f "$PYWAL_COLORS" ]] || { echo "No colors file"; return 1; }
    [[ -f "$tpl"        ]] || { echo "No template";    return 1; }
    mkdir -p "$(dirname "$out_file")"

    # считываем 16 hex-цветов
    mapfile -t colors < "$PYWAL_COLORS"

    # собираем sed-скрипт
    local sed_script=()
    local i hex r g b

    for i in {0..15}; do
        hex="${colors[$i]}"                   # "#RRGGBB"
        hex_esc="${hex//\//\\/}"              # экранируем /
        # 1) {{hex[i]}}
        sed_script+=( -e "s/\{\{\s*hex\[\s*${i}\s*\]\s*\}\}/${hex_esc}/g" )

        # готовим rgb
        h="${hex#"#"}"
        r=$((16#${h:0:2})); g=$((16#${h:2:2})); b=$((16#${h:4:2}))
        # 2) {{rgb[i]}}
        sed_script+=( -e "s/\{\{\s*rgb\[\s*${i}\s*\]\s*\}\}/${r},${g},${b}/g" )

        # 3) {{rgba[i][Float]}}  — захватываем Float
        #    в replacement подставляем \1
        sed_script+=( -e "s/\{\{\s*rgba\[\s*${i}\s*\]\[\s*([0-9.]+)\s*\]\s*\}\}/rgba(${r},${g},${b},\1)/g" )
    done

    # выполняем замену одним sed
    sed -E "${sed_script[@]}" "$tpl" > "$out_file"
}

if [[ $1 && $2 ]]; then
    generate_theme "$1" "$2"
fi


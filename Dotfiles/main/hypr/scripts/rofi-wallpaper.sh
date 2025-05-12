#!/bin/bash
#Переменные
CAVA_CONFIG="$HOME/.config/cava/config"
HYPRLAND_COLORS="$HOME/.config/hypr/conf/colors.conf"
WALLPAPERS_DIR="$HOME/Wallpapers"
PYWAL_COLORS="$HOME/.cache/wal/colors"
PYWAL_COLORS_HYPRLAND="$HOME/.cache/wal/colors-hyprland.conf"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
ROFI_THEME_FILE="$HOME/.config/rofi/themes/rofi-wal-theme.rasi"
ROFI_WALLPAPER_THEME_FILE="$HOME/.config/rofi/themes/wallpaper-wal-theme.rasi"
HYPRMODE_THEME_FILE="$HOME/.config/rofi/themes/hyprmod-wal-theme.rasi"
THUMB_CACHE="$HOME/.cache/rofi_wallpaper_thumbnails"
mkdir -p "$THUMB_CACHE"

#Начало Скрипта
cd "$WALLPAPERS_DIR" || exit

# Создаем временный файл для данных Rofi
ROFI_DATA=$(mktemp)

# Обрабатываем все файлы перед запуском Rofi
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [[ "$filename" == *.mp4 || "$filename" == *.MP4 ]]; then
        thumb="$THUMB_CACHE/${filename}.png"
        # Генерируем превью только если его нет
        if [ ! -f "$thumb" ]; then
            ffmpeg -i "$file" -ss 00:00:01 -vframes 1 -vf "scale=200:-1" "$thumb" 2>/dev/null
        fi
        icon="$thumb"
    else
        icon="$file"
    fi
    # Добавляем запись с иконкой в буфер
    echo -en "$filename\0Icon\x1f$icon\n"
done < <(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.png" -o -iname "*.mp4" -o -iname "*.gif" \) -print0) > "$ROFI_DATA"

# Запускаем Rofi с готовыми данными
SELECTED_WALLPAPER=$(cat "$ROFI_DATA" | rofi -dmenu -config "~/.config/rofi/wallpaper.rasi" -p "Select Wallpaper: ")
rm "$ROFI_DATA"

[ -z "$SELECTED_WALLPAPER" ] && exit

# Установка Обоев
if [[ "$SELECTED_WALLPAPER" == *.mp4 ]] || [[ "$SELECTED_WALLPAPER" == *.MP4 ]]; then
  notify-send "Applying Video Wallpaper:" "$SELECTED_WALLPAPER"
  pkill swww-daemon 
  pkill mpvpaper
  output=$(hyprctl monitors | awk '/Monitor/ {print $2; exit}')
  mpvpaper -o "--loop --no-audio" "$output" "$SELECTED_WALLPAPER" &
  wal -i "$SELECTED_WALLPAPER" --backend Colorz
else
  notify-send "Applying Static Wallpaper:" "$SELECTED_WALLPAPER"
  pkill mpvpaper
  pkill swww-daemon
  swww-daemon &
  swww img "$SELECTED_WALLPAPER" --transition-type none
  wal -i "$SELECTED_WALLPAPER" --backend Wal
fi

# Темы Других Приложений: Rofi, Cava, Rofi, Hyprlock, Hyprmode

# Rofi THEME
    mapfile -t colors < "$PYWAL_COLORS"
    cat <<EOF > "$ROFI_THEME_FILE"
        * {
            background-color : ${colors[3]}45;
            color: #ffffff;;
            border: 0;
            border-radius: 5px;
        }
        window {
            padding: 10px;
            border-radius: 5px;
        }
        mainbox {
            border: 0;
            padding: 10px;
        }
        listview {
            background-color : ${colors[1]}45;
            border-radius: 5px;
            margin: 0;
            padding: 0;
        }
        element {
            padding: 8px 15px;
            border: 0;
            margin: 0;
            background-color: #333333;
            color: #ffffff;
            border-radius: 5px;
            height: 35px;
        }
        element selected {
            background-color: ${colors[3]};
            /*color: #ffffff;*/
            color: ${colors[2]};
        }
        element highlighted {
                background-color: #555555;
            color: #ffffff;
        }
EOF

# CAVA THEME / CONFIG:
    mapfile -t colors < "$PYWAL_COLORS"
    cat <<EOF > "$CAVA_CONFIG"
        ## Configuration file for CAVA.
        # Remove the ; to change parameters.
        [color]
        #background = '#000000'  # Цвет фона (color0 из pywal)
        gradient = 1
        gradient_count = 5
        foreground = '${colors[1]}'  # Основной цвет (color7 из pywal)
        gradient_color_1 = '${colors[0]}'  # Градиент 1 (color5 из pywal)
        gradient_color_2 = '${colors[1]}'  # Градиент 2 (color4 из pywal)
        gradient_color_3 = '${colors[8]}'  # Градиент 3 (color2 из pywal)
        gradient_color_4 = '${colors[12]}'  # Градиент 4 (color3 из pywal)
        gradient_color_5 = '${colors[14]}'  # Градиент 5 (color1 из pywal)
        [general]
        bars = 16            # Количество столбцов
        framerate = 60       # Частота обновления
        autosens = 1         # Автонастройка чувствительности
        sensitivity = 100    # Базовый уровень чувствительности
        [input]
        method = pulse       # Использует PulseAudio (для PipeWire тоже работает)
        source = auto        # Автовыбор аудиопотока
        [output]
        method = ncurses     # Вывод в терминал
        [smoothing]
        integral = 25
EOF

#Запись Wallpaper Темы для Rofi Лаунчера
    mapfile -t colors < "$PYWAL_COLORS" 
    cat <<EOF > "$ROFI_WALLPAPER_THEME_FILE"
        /** Default settings, every widget inherits from this. */
        * {
            background-color: transparent;
            border-radius:0.5em;
            text-color:white;
        }

        entry {
            border: 2px 0px;
            border-color:  ${colors[3]}60;
            background-color: ${colors[3]}60;
            padding:       4px;
            placeholder:       "Type to filter";
            placeholder-color: transparent;
            font: inherit;
            cursor: text;
        }
        inputbar {
            spacing: 0;
            children: [  icon-keyboard, entry, mode-switcher ];
            font:   "mono 14";
        }

        mode-switcher {
            spacing: 2px;
            border: 2px;
            border-radius: 0px 4px 4px 0px;
            border-color: none;
            background-color: none;
            font: inherit;
        }
        button {
            background-color: grey;
            border-color: darkgrey;
            font: inherit;
            cursor: pointer;
        }
        button selected {
            background-color: lightgrey;
            text-color:       white;
        }

        icon-keyboard {
            border:        4px 4px 4px 4px;
            border-color:  none;
            background-color: none;
            padding: 0px 10px 0px 10px;
            expand: false;
            size: 1.5em;
            filename: "keyboard";
        }

        window {
            anchor: center;
            location: center;
            width:50%;
            background-color: ${colors[2]}75; /* ФОН ROFI*/
            padding:1.2em;
            border-color: ${colors[12]};
            border:  0.2em 0.2em 0.2em;
        }
        mainbox {spacing:1em;}
        listview {
            lines: 3;
            columns: 6;
            spacing: 1.2em;
            fixed-columns: true;
        }
        element {
            orientation:vertical;
            border:0.15em;
            border-radius:12px ;
            border-color:${colors[2]};
            background-color: ${colors[14]}85; /* Фон Плиток*/
            cursor: pointer;
        }

        element selected {
            background-color:${colors[13]}80; 
            border-color: ${colors[12]};
            text-color:black;
            color: ${colors[1]};
        }
        element-icon {
            size: 96px;
            cursor: inherit;
        }
        element-text {
            horizontal-align: 0.5;
            cursor: inherit;
            color: ${colors[0]};
        }
EOF

# HYPRLOCK THEME
    mapfile -t colors < <(sed 's/^[^=]*=\s*//' "$PYWAL_COLORS_HYPRLAND")
    cat <<EOF > "$HYPRLOCK_CONFIG" 
        # ~/.config/hypr/hyprlock.conf

        general {
            disable_loading_bar = true
            hide_cursor = true
            grace = 0
        }
        background {
            monitor =
            path = $WALLPAPERS_DIR/$SELECTED_WALLPAPER
            blur_passes = 3
            blur_size = 6
            noise = 0.045
            contrast = 1.3000
            brightness = 0.4650
        }
        input-field {
            monitor =
            size = 250, 50
            outline_thickness = 3
            dots_size = 0.35
            dots_spacing = 0.25
            dots_center = true
            outer_color = ${colors[13]}
            inner_color = ${colors[9]}
            font_color = ${colors[10]}
            fade_on_empty = false
            placeholder_text = Enter Password
            position = 0, -50  # Поднято выше
            halign = center
            valign = center
        }
        # Время
        label {
            monitor =
            text = cmd[update:1000] date +'%H:%M'
            position = 0, 180
            halign = center
            valign = center
            color = ${colors[8]}
            font_size = 64
            font_family = SF Mono
        }
        # Дата
        label {
            monitor =
            text = cmd[update:1000] date +'%A, %d %B'
            position = 0, 100
            halign = center
            valign = center
            color = ${colors[13]}
            font_size = 20
            font_family = SF Mono
        }
        # Информация о треке (скрывается при неактивном плеере)
        label {
            monitor =
            text = cmd[update:1000] if playerctl status >/dev/null 2>&1; then playerctl metadata --format '{{artist}} - {{title}}'; else echo ""; fi
            position = 0, -150
            halign = center
            valign = center
            color = ${colors[7]}
            font_size = 15
            font_family = SF Mono
        }
EOF
# HYPRMODE THEME
    mapfile -t colors < "$PYWAL_COLORS" 
    cat <<EOF > "$HYPRMODE_THEME_FILE" 
* {
    /* Основные настройки */
        background-color: ${colors[13]}45;
        border:0;
    /* Размеры и отступы */
        width: 20%;
        padding: 10px;
        margin: 0;
        border-radius: 0.4 em;
        spacing: 0;
    /* Стиль списка */
        listview: true;
        lines: 5;
        fixed-height: true; 
    /* Убираем иконки */
        show-icons: false;
}
#inputbar {
    children: [prompt, entry];
}
#entry {
    padding: 5px;
    text-color: #CDD6F4;
    border: 3;
    background-color: #2c2c2ce7;
    border-color: #dddddd;
}
#prompt {
    padding: 5px;
    text-color:${colors[15]};
    background-color:#00000000;
    border:0;
}
#listview {
    padding: 5px;
    dynamic: true;
    scrollbar: false;
    background-color:#00000000;
}
#element {
    padding: 5px;
    background-color: ${colors[2]};
    border-color: ${colors[9]};
    border: 0;
    border: 4px ;
    margin: 4px;
}
#element selected {
    text-color: ${colors[0]};
    background-color: ${colors[13]};
    border-color: ${colors[11]};
    border:4;
}
EOF

# HYPRLAND COLORS
    mapfile -t colors < "$PYWAL_COLORS"
    cat <<EOF > "$HYPRLAND_COLORS"
        ################
        ###  Colors  ###
        ################
        $(for i in {1..16}; do 
            color_index=$((i-1))
            echo "\$color$i = 0xff${colors[$color_index]#\#}"
        done)
EOF

#Конец Скрипта
    hyprctl reload 
    exit
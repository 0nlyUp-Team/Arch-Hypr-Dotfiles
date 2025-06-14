#!/bin/bash

USER_NAME="${USER}"
HOUR=$(date +%H)
TIME=$(date "+%H:%M")
WEEKDAY=$(LC_ALL=ru_RU.UTF-8 date "+%A")  # день недели по-русски

# Приветствие по времени суток
if (( HOUR >= 5 && HOUR < 12 )); then
    GREETING="🌅 Доброе утро"
elif (( HOUR >= 12 && HOUR < 17 )); then
    GREETING="🌤 Добрый день"
elif (( HOUR >= 17 && HOUR < 22 )); then
    GREETING="🌇 Добрый вечер"
else
    GREETING="🌙 Доброй ночи"
fi

# Путь до конфига
LOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

# Генерация конфига с подставленными значениями
cat > "$LOCK_CONF" <<EOF
background {
  monitor =
  path = \$HOME/.config/lock.jpeg
  blur_passes = 2
  blur_size = 7
  noise = 0.023
  contrast = 0.8916
  brightness = 0.8172
  vibrancy = 0.1696
  vibrancy_darkness = 0.0
}

general {
    hide_cursor = 1
    ignore_empty_input = 1
}

label {
    text = <b>$USER_NAME</b>
    color = rgba(255, 255, 255, 0.9)
    font_size = 18
    position = 0, -400
    halign = center
    valign = center
}

label {
    text = cmd[update:1000] echo "<b>\$(date +%H:%M)</b>"
    color = rgba(255, 255, 255, 1.0)
    font_size = 86
    position = 0, 200
    halign = center
    valign = center
}

label {
    text = <b> $WEEKDAY</b>
    font_size = 18
    position = 0, 125
    halign = center
    valign = center
    color = rgba(255, 255, 255, 1.0)
  }

label {
    text = <b>$GREETING, $USER_NAME! </b>
    font_size = 18
    position = 0, 310
    halign = center
    valign = center
    color = rgba(255, 255, 255, 1.0)
}

image {
    path = \$HOME/.config/hypr/avatar.png
    size = 65
    border_size = 2
    border_color = rgba(255,255,255,0.8)
    rounding = 100
    position = 0, -330
}

input-field {
    fail_text = <b>Wrong Pass</b>
    placeholder_text = <b>Enter Pass</b>
    hide_input = 0
    fade_on_empty = 0
    fade_timeout = 10
    size = 150, 35
    position = 0, -450
    halign = center
    valig = center
    outline_thickness = 2
    rounding = 25
    dots_center = 1
    dots_rounding = -1
    dots_size = 0.4
    dots_spacing = 0.10
    numlock_color = rgba(255,255,255,1.0)
    capslock_color = rgba(255,255,255,1.0)
    outer_color = rgba(255,255,255,1.0)
    inner_color = rgba(0,0,0,0.4)
    font_color = rgba(255,255,255,1.0)
    fail_color = rgba(245, 16, 46, 1.0)
}
EOF

img="$HOME/.config/lock.jpeg"
grim -t jpeg -q 42 "$img"
hyprlock
rm "$img"


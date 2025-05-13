#!/bin/bash
config=~/.config/rofi/hyprmode.rasi
theme=$USER/.config/rofi/themes/hyprmod-wal-theme.rasi
selected_mode=$(echo -e "Reload\nMinimal\nGame\nDwindle\nMaster\nKawase" | rofi -dmenu -config "/home/unner/.config/rofi/hyprmode.rasi" -p "HyprMode:")
log(){
    notify-send -t 5000 -u low -i dialog-information "Sucess:" "Switched to $selected_mode mode"
}

#selected_mode=$(echo -e "Low-End\nDefault\nGame\nCustom-1\nCustom-2" | rofi -dmenu -theme-str 'window {width: 20%;} listview {lines: 5;}' -p "Select HyprMode:")
[[ -z "$selected_mode" ]] && exit 0
case "$selected_mode" in
    "Reload")
        notify-send -t 5000 -u low -i dialog-information "Sucess:" "Hyprland Reloaded!"
        hyprctl reload  ;;
    "Minimal")
        hyprctl reload
        log
        hyprctl --batch "\
            keyword general:gaps_in 4;\
            keyword general:gaps_out 8;\
            keyword general:border_size 0;\
            keyword general:col.active_border rgba(ffffff00) rgba(ffffff00) 45deg;\
            keyword general:col.inactive_border rgba(ffffff00) rgba(ffffff00) 45deg;\
            keyword decoration:active_opacity 1.0;\
            keyword decoration:inactive_opacity 1.0;\
            keyword misc:vfr true;\
            keyword decoration:blur:enabled false;\
            keyword animations:enabled false;\
            keyword decoration:shadow:enabled false;\
            keyword misc:vfr true"
        # Fkin Opacity
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(thunar)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(mousepad)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(waypaper)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(code-oss)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(nm-connection-editor)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(org.pulseaudio.pavucontrol)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(Rofi)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(vesktop)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(LibreWolf)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(org.gnome.FileRoller)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(Gimp-2.10)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(Electron)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(Xdg-desktop-portal-gtk)$"
            hyprctl keyword windowrulev2 "opacity 1.0 1.0,class:^(org.gnome.Nautilus)$"           
        ;;
    "Game")
        hyprctl reload
        log
        hyprctl --batch "\
            keyword animations:enabled false;\
            keyword general:gaps_in 4;\
            keyword general:gaps_out 8;\
            keyword decoration:rounding 0;\
            keyword decoration:blur:enabled false;\
            keyword decoration:blur:size 0;\
            keyword decoration:blur:passes 0;\
            keyword decoration:active_opacity 1.0;\
            keyword decoration:inactive_opacity 1.0;\
            keyword decoration:shadow:enabled false;\
            keyword general:border_size 2;\
            keyword general:col.active_border rgba(ffffff00) rgba(ffffff00) 45deg;\
            keyword general:col.inactive_border rgba(ffffff00) rgba(ffffff00) 45deg;\
            keyword general:layout dwindle; \
            keyword misc:vfr false" ;;
    "Dwindle")
        hyprctl reload
        log
        hyprctl --batch "\
            keyword general:layout dwindle;\
            keyword decoration:shadow:enabled false;\
            keyword general:border_size 0;\
            keyword decoration:active_opacity 1.0;\
            keyword decoration:inactive_opacity 1.0\
            keyword misc:vfr false;" ;;
    "Master")
        hyprctl reload
        log
        hyprctl --batch "\
            keyword general:layout master;\
            keyword decoration:shadow:enabled false;\
            keyword general:border_size 0;\
            keyword decoration:active_opacity 1.0;\
            keyword decoration:inactive_opacity 1.0\
            keyword misc:vfr false;" ;;
    "Kawase")
        #hyprctl reload
        log
        hyprctl --batch "\
            keyword decoration:blur:enabled true;\
            keyword decoration:blur:size 8;\
            keyword decoration:blur:passes 3;\
            keyword decoration:blur:new_optimizations true;\
            keyword decoration:blur:ignore_opacity true;"
        ;;
    *)
        notify-send -t 5000 -u critical -i dialog-error "Error:" "Unknown mode: $selected_mode"
        exit 1 ;;
esac


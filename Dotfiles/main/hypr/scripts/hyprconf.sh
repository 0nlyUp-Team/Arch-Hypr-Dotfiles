#!/bin/bash
cfg="$HOME/.config/rofi/hyprmode.rasi"
menu() { rofi -dmenu -config "$cfg" -p "$1:"; }
t() { [[ $(hyprctl getoption "$2" | grep int: | awk '{print $2}') == 0 ]] && hyprctl keyword "$2" true || hyprctl keyword "$2" false; notify-send "$1 toggled"; }
while :; do case $(echo -e "Borders\nBlur\nAnimation\nGaps" | menu "Main") in
  Borders) while :; do case $(echo -e "Toggle Borders\nSet Border Size\nToggle Rounding\nSet Rounding Size\nBack" | menu "Borders") in
    "Toggle Borders") t "Borders" general:border_size ;;
    "Set Border Size") s=$(menu "Border Size"); [[ $s ]] && hyprctl keyword general:border_size "$s" ;;
    "Toggle Rounding") t "Rounding" decoration:rounding ;;
    "Set Rounding Size") r=$(menu "Rounding Size"); [[ $r ]] && hyprctl keyword decoration:rounding "$r" ;;
    Back|"") break ;; esac; done ;;
  Blur) while :; do case $(echo -e "Toggle\nSet Size\nSet Passes\nBack" | menu "Blur") in
    Toggle) t "Blur" decoration:blur:enabled ;;
    "Set Size") s=$(menu "Blur Size"); [[ $s ]] && hyprctl keyword decoration:blur:size "$s" ;;
    "Set Passes") p=$(menu "Blur Passes"); [[ $p ]] && hyprctl keyword decoration:blur:passes "$p" ;;
    Back|"") break ;; esac; done ;;
  Animation) while :; do case $(echo -e "Toggle\nBack" | menu "Animation") in
    Toggle) t "Animation" animations:enabled ;;
    Back|"") break ;; esac; done ;;
  Gaps) while :; do case $(echo -e "Toggle\nSet In\nSet Out\nBack" | menu "Gaps") in
    Toggle) g=$(hyprctl getoption general:gaps_in | grep int: | awk '{print $2}'); [[ $g == 0 ]] && hyprctl --batch "keyword general:gaps_in 4; keyword general:gaps_out 8" || hyprctl --batch "keyword general:gaps_in 0; keyword general:gaps_out 0"; notify-send "Gaps toggled" ;;
    "Set In") gi=$(menu "Gaps In"); [[ $gi ]] && hyprctl keyword general:gaps_in "$gi" ;;
    "Set Out") go=$(menu "Gaps Out"); [[ $go ]] && hyprctl keyword general:gaps_out "$go" ;;
    Back|"") break ;; esac; done ;;
  "") exit ;; esac; done

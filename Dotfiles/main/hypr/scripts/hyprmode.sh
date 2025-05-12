#!/bin/bash
echo "HyprMode"
hyprctl reload

if [[ "$1" == "low" ]];then
hyprctl --batch "\
    keyword misc:vfr true;\
    keyword decoration:blur:enabled false;\
    keyword animations:enabled false;
    keyword decoration:shadow:enabled false"
fi

if [[ "$1" == "def" ]];then
hyprctl --batch "\
    keyword misc:vfr false;\
    keyword general:border_size 2;\
    keyword general:gaps_in 12;\
    keyword general:gaps_out 12;\
    keyword animations:enabled true;\
    keyword decoration:rounding 8;\
    keyword decoration:blur:enabled true;\
    keyword decoration:shadow:enabled true"
fi

if [[ "$1" == "game" ]];then
hyprctl --batch "\
    keyword misc:vfr false;\
    keyword general:border_size 0;\
    keyword general:gaps_in 0;\
    keyword general:gaps_out 0;\
    keyword animations:enabled false;\
    keyword decoration:rounding 0;\
    keyword decoration:blur:enabled false;
    keyword decoration:shadow:enabled false"
fi
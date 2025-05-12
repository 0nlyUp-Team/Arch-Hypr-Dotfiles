#!/bin/bash

WAL_COLORS="$HOME/.cache/wal/colors"

if [[ ! -f "$WAL_COLORS" ]]; then
    echo "Файл $WAL_COLORS не найден. Сначала запусти 'wal'."
    exit 1
fi

mapfile -t COLORS < "$WAL_COLORS"

for i in "${!COLORS[@]}"; do
    COLOR="${COLORS[$i]}"
    r=$((16#${COLOR:1:2}))
    g=$((16#${COLOR:3:2}))
    b=$((16#${COLOR:5:2}))

    if [[ "$1" == "-n" ]]; then
        # кружок + имя в новой строке
        printf "\e[38;2;%d;%d;%dm●\e[0m color%-2s: %s\n" "$r" "$g" "$b" "$i" "$COLOR"
    else
        # просто кружки в одну строку
        printf "\e[38;2;%d;%d;%dm● \e[0m" "$r" "$g" "$b"
    fi
done

[[ "$1" != "-n" ]] && echo


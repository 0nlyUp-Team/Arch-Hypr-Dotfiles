#!/bin/bash

if [[ "$1" == "hover" ]]; then
    echo '{"text": "☰", "tooltip": "Меню", "class": "custom-menu-expanded"}'
else
    echo '{"text": "☰", "tooltip": "Меню", "class": "custom-menu"}'
fi

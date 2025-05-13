#!/bin/bash
notify-send -t 5000 -u critical -i dialog-error "Error:" "Example"
notify-send -t 5000 -u normal -i dialog-warning "Debug:" "Example"
notify-send -t 5000 -u low -i dialog-information "Sucess:" "Example"
notify-send -t 5000 -i dialog-password "Password:" "Example"
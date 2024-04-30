#!/bin/bash
menu="$1"

if [ "$menu" = "appmenu" ]; then
    rofi -show drun -theme clean
elif [ "$menu" = "powermenu" ]; then
    rofi -modi 'Powermenu:~/.config/rofi/powermenu.sh' -show Powermenu -theme powermenu
fi

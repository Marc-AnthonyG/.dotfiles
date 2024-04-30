#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Logout\0icon\x1fsystem-log-out\n"
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Reboot\0icon\x1fsystem-reboot\n"
    echo -en "Lock\0icon\x1fsystem-lock-screen\n"
else
    if [ "$1" = "Shutdown" ]; then
        shutdown now
    elif [ "$1" = "Logout" ]; then
        i3 exit logout
    elif [ "$1" = "Reboot" ]; then
        reboot 
    elif [ "$1" = "Suspend" ]; then
        systemctl suspend
    elif [ "$1" = "Lock" ]; then
        i3lock
    fi
fi

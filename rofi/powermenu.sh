#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Logout\0icon\x1fsystem-log-out\n"
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Hibernate\0icon\x1fsystem-suspend-hibernate\n"
    echo -en "Reboot\0icon\x1fsystem-reboot\n"
    echo -en "Lock\0icon\x1fsystem-lock-screen\n"
else
    if [ "$1" = "Shutdown" ]; then
        sudo shutdown 0 
    elif [ "$1" = "Logout" ]; then
        i3 exit logout
    elif [ "$1" = "Reboot" ]; then
        sudo shtudown -r 
    elif [ "$1" = "Suspend" ]; then
        systemctl suspend
    elif [ "$1" = "Lock" ]; then
        i3exit lock
    elif [ "$1" = "Hibernate" ]; then
        sudo systemctl hibernate
    fi
fi

#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: No parameter provided."
    exit 1
fi

# Check if the parameter is a number
if [[ ! "$1" =~ ^yes|no$ ]]; then
    echo "Error: Parameter is not yes or no."
    exit 1
fi

yabai -m query --spaces | jq -r '.[] | .index' | while read index; do
    yabai -m config --space "$index" bottom_padding 10
done

if [ "$1" == "yes" ]; then
    yabai -m signal --add event=space_changed label=screen_padding_display_changed action="~/.config/yabai/script/add_padding.sh 2" active="$1"
    yabai -m signal --add event=space_created label=screen_padding_display_created action="~/.config/yabai/script/add_padding.sh 2" active="$1"
    yabai -m signal --add event=space_destroyed label=screen_padding_display_destroyed action="~/.config/yabai/script/add_padding.sh 2" active="$1"
    ~/.config/yabai/script/add_padding.sh 2
else
    yabai -m signal --remove screen_padding_display_changed
    yabai -m signal --remove screen_padding_display_created
    yabai -m signal --remove screen_padding_display_destroyed
fi

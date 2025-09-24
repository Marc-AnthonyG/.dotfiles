#!/bin/bash

get_icon() {
    case $1 in
    "google-chrome") echo "" ;;
    "Alacritty") echo "" ;;
    "Spotify") echo "󰓇" ;;
    "Obsidian") echo "󱞎" ;;
    "org.kde.dolphin") echo "" ;;
    "org.pulseaudio.pavucontrol") echo "" ;;
    "gimp") echo "" ;;
    *) echo "*" ;;
    esac
}

workspace_windows=$(hyprctl workspaces -j)
active_workspace=$(hyprctl activewindow -j | jq '.workspace.id')
windows=$(hyprctl clients -j)

text=""

max_workspace=$(echo "$workspace_windows" | jq -r '.[] | .id' | sort -n | tail -n1)
for workspace in $(seq 1 ${max_workspace:-8}); do
    workspace_apps=$(echo "$windows" | jq -r ".[] | select(.workspace.id == $workspace) | .class" | sort -u)

    icons=""
    if [ ! -z "$workspace_apps" ]; then
        while IFS= read -r app; do
            if [ ! -z "$app" ]; then
                icon=$(get_icon "$app")
                icons="$icons$icon "
            fi
        done <<<"$workspace_apps"
    fi

    icons="${icons% }"

    if [ "$workspace" = "$active_workspace" ]; then
        text="${text} <b>$workspace${icons:+:$icons}</b>"
    else
        text="${text} $workspace${icons:+:$icons}"
    fi
done

text="${text# }"
echo "{\"text\": \"$text\"}"

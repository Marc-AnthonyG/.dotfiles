#!/bin/sh

sketchybar --set $NAME background.drawing=$SELECTED 

if [[ $SENDER == "window_change" || $SENDER == "space_change" ]]; then
   sid="${NAME: -1}"
   LABEL=""
   APPS=$(echo $(yabai -m query --windows --space $sid)| jq '.[].app')
 
   if [[ -n "$APPS" ]]; then
     APPS_ARR=()
     while read -r line; do APPS_ARR+=("${line}"); done <<< "$APPS"
 
     LENGTH=${#APPS_ARR[@]}

     for j in "${!APPS_ARR[@]}"; do
       APP=$(echo ${APPS_ARR[j]} | sed 's/"//g')
       ICON=$($HOME/.config/sketchybar/plugins/icons.sh "$APP")
       LABEL+="$ICON"
       if [[ $j < $(($LENGTH-1)) ]]; then
         LABEL+=" "
       fi
     done
   else
     LABEL+="_"
   fi
 
   sketchybar --set space.$sid label="$LABEL"
fi

#!/usr/bin/env sh

NOTIFICATIONS="$(gh api notifications)"
COUNT="$(echo "$NOTIFICATIONS" | jq 'length')"
args=()
if [ "$NOTIFICATIONS" = "[]" ]; then
  args+=(--set $NAME icon=􀋚 label="0")
else
  args+=(--set $NAME icon=􀝗 label="$COUNT")
fi

args+=(--remove '/github.notification\.*/')

COUNT=0

while read -r repo url type title 
do
  COUNT=$((COUNT + 1))
  IMPORTANT="$(echo "$title" | egrep -i "(deprecat|break|broke)")"
  COLOR=0xff72cce8
  PADDING=0
  case "${type}" in
    "'Issue'") COLOR=0xff9dd274; ICON=􀍷; PADDING=0; URL="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
    ;;
    "'Discussion'") COLOR=0xffe1e3e4; ICON=􀒤; PADDING=0; URL="https://www.github.com/notifications"
    ;;
    "'PullRequest'") COLOR=0xffba9cf3; ICON="􀙡"; PADDING=4; URL="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
    ;;
  esac
  
  args+=(
         --add item github.notification.$COUNT popup.github.bell                                      \
         --set github.notification.$COUNT background.padding_left=7  background.padding_right=7       \
               background.color=0xff3b4261 icon.background.height=1 icon.background.y_offset=-12      \
               background.drawing=on label.font.size="10.0" icon.font.size="10.0"                     \
               icon.background.color=$COLOR icon.padding_left="$PADDING"  icon.color=$COLOR           \
               icon="$ICON $(echo "$repo" | sed -e "s/^'//" -e "s/'$//"):"                            \
               label="$(echo "$title" | sed -e "s/^'//" -e "s/'$//")"                                 \
               script='case "$SENDER" in
                        "mouse.entered") sketchybar --set $NAME background.color=0xff24283b
                        ;;
                        "mouse.exited") sketchybar --set $NAME background.color=0xff3b4261
                        ;;
                        esac' \
               click_script="open $URL;
                             sketchybar --set github.bell popup.drawing=off"
--subscribe github.notification.$COUNT mouse.entered mouse.exited)

done <<< "$(echo "$NOTIFICATIONS" | jq -r '.[] | [.repository.name, .subject.latest_comment_url, .subject.type, .subject.title] | @sh')"

sketchybar -m "${args[@]}" 

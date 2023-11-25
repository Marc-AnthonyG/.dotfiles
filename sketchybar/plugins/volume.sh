#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME=$INFO

  case $VOLUME in
    [5-9][0-9]|100) ICON="󰕾"
    ;;
    [1-9]|[1-4][0-9]) ICON="󰖀"
    ;;
    *) ICON="󰖁"
  esac

  sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
fi

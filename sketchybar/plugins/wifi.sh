#!/bin/sh

if [ "$SENDER" = "wifi_change" ]; then
  WIFI=${INFO:-"Not Connected"}
  ICON=${INFO+"󰖩"};
  sketchybar --set $NAME icon="$ICON" label="$INFO"
fi

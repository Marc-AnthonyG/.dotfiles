#!/bin/bash

LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

case "$LAYOUT" in
    "Canadian") sketchybar --set keyboard label="CA" drawing=on;;
    "\"Canadian - CSA\"") sketchybar --set keyboard label="CSA" drawing=on;;
    *) sketchybar --set keyboard drawing=off;;
esac

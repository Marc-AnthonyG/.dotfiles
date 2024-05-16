#!/usr/bin/env sh

BAR_COLOR=0x15ffffff

lock() {
  sketchybar --bar y_offset=-32 \
                   margin=-200 \
                   notch_width=0 \
                   color=0x000000
}

unlock() {
  sketchybar --animate sin 30 \
             --bar y_offset=0 \
                   notch_width=200 \
                   margin=8 \
                   color=0x80292e42
}

case "$SENDER" in
  "lock") lock
  ;;
  "unlock") unlock
  ;;
esac

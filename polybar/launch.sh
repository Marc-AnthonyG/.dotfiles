#!/usr/bin/env bash

polybar-msg cmd quit
#killall -q polybar to nuke


# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
polybar side 2>&1 | tee -a /tmp/polybar2.log & disown

echo "polybar succesfully launch"

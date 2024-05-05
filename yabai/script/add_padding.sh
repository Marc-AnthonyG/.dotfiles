#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: No parameter provided."
    exit 1
fi

if [[ ! "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Parameter is not a number."
    exit 1
fi

yabai -m query --displays --display "$1" | jq '.spaces[]' | while read space; do
   yabai -m config --space "$space" bottom_padding 180
done

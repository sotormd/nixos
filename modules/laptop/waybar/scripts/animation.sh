#!/usr/bin/env bash

FILE="/tmp/waybar-noanimation"

if [[ -e "$FILE" ]]; then
  rm "$FILE"
else
  touch "$FILE"
fi

#!/usr/bin/env bash

FILE="$XDG_RUNTIME_DIR/waybar-noanimation"

if [[ -e "$FILE" ]]; then
  rm "$FILE"
else
  touch "$FILE"
fi

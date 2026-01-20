#!/usr/bin/env bash

STATUS="$(@playerctl@ status)"

TITLE="$(
  @playerctl@ metadata title |
    sed -E '
      s/ -.*//;
      s/\(.*\)//g;
      s/\[.*\]//g;
      s/^[[:space:]]*//;
      s/[[:space:]]*$//;
      s/&/\&amp;/g;
      s/</\&lt;/g;
      s/>/\&gt;/g;
      s/"/\\"/g
    '
)"

ARTISTS="$(
  @playerctl@ metadata artist |
    awk -F',' '{print $1 ", " $2}' |
    sed -E '
      s/^[[:space:]]*//;
      s/[[:space:]]*$//;
      s/, *$//;
      s/&/\&amp;/g;
      s/</\&lt;/g;
      s/>/\&gt;/g;
      s/"/\\"/g
    '
)"

if [[ -e "$XDG_RUNTIME_DIR/waybar-noanimation" ]]; then
  PLAYING_CLASS="playerctl-playing-noanimation"
else
  PLAYING_CLASS="playerctl-playing"
fi

if [[ -z "$TITLE" || "$TITLE" == "Advertisement" ]]; then
  echo '{"text": "", "class": "playerctl-stopped"}'
elif [[ "$STATUS" == "Playing" ]]; then
  echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"$PLAYING_CLASS\"}"
else
  echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"playerctl-paused\"}"
fi

#!/usr/bin/env bash

STATUS="$(sysctl -n kernel.unprivileged_userns_clone)"

if [[ "$STATUS" == "1" ]]; then
  echo '{"text": "<span size='\''12000'\''>󰆦</span>", "class": "userns-enabled"}'
else
  echo '{"text": "<span size='\''12000'\''>󱐜</span>", "class": "userns-disabled"}'
fi

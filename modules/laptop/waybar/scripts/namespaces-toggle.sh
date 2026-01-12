#!/usr/bin/env bash

KEY="kernel.unprivileged_userns_clone"

current_value="$(sysctl -n "$KEY" 2>/dev/null)"
rc=$?

if [[ $rc -ne 0 ]]; then
  notify-send -u critical "Namespaces" "Error: $KEY not supported"
  exit 1
fi

if [[ "$current_value" == "1" ]]; then
  pkexec sysctl -w "$KEY=0" >/dev/null
else
  pkexec sysctl -w "$KEY=1" >/dev/null
fi

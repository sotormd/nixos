change="$1"

# Apply brightness change
@brightnessctl@ set "$change"

# Compute % value
lvl=$(@brightnessctl@ g)
max=$(@brightnessctl@ m)
pct=$(( lvl * 100 / max ))

# Send dunst progress bar
@dunstify@ -a "brightness" -r 9998 "Brightness: $pct%" -h int:value:"$pct" -t 1500


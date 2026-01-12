# change this to +5% or -5% when binding keys
change="$1"

# apply volume change
wpctl set-volume @DEFAULT_AUDIO_SINK@ "$change"

# get current volume as 0–100 integer
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2 * 100}')

# show dunst progress bar
dunstify -a "volume" -r 9999 "Volume: $vol%" -h int:value:"$vol" -t 1500


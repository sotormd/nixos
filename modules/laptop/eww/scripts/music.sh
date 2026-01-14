#!/usr/bin/env bash

COVER="/tmp/.music_cover.jpg"
DEFAULT_COVER="images/music.png"

STATUS=$(@playerctl@ status)
TITLE=$(
  @playerctl@ metadata title |
  sed -E 's/ -.*//; s/\(.*\)//g; s/\[.*\]//g; s/^[[:space:]]*//; s/[[:space:]]*$//'
)
ARTISTS=$(
  @playerctl@ metadata artist |
  awk -F',' '{print $1 ", " $2}' |
  sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//; s/, *$//'
)

## Get status
get_status() {
    if @playerctl@ status 2>/dev/null | grep -qi "playing"; then
        echo "󰏥"
    else
        echo "󰐌"
    fi
}

## Get song title
get_song() {
    if [[ -z "$TITLE" ]]; then
        echo "-"
    else
        echo "$TITLE"
    fi
}

## Get artist
get_artist() {
    if [[ -z "$ARTISTS" ]]; then
        echo "-"
    else
        echo "$ARTISTS"
    fi
}

## Get progress percentage
get_time() {
    pos=$(@playerctl@ position 2>/dev/null)
    len=$(@playerctl@ metadata mpris:length 2>/dev/null)

    if [[ -z "$pos" || -z "$len" ]]; then
        echo "0"
    else
        # Convert microseconds to seconds
        pos_sec=$(printf "%.0f" "$pos")
        len_sec=$(printf "%.0f" "$(echo "$len / 1000000" | @bc@)")
        [[ "$len_sec" -eq 0 ]] && echo "0" && return
        percent=$(( 100 * pos_sec / len_sec ))
        echo "$percent"
    fi
}

## Get current time (e.g. 1:45)
get_ctime() {
    pos=$(@playerctl@ position 2>/dev/null)
    if [[ -z "$pos" ]]; then
        echo "0:00"
    else
        date -u -d @"''${pos%.*}" +%M:%S
    fi
}

## Get total time (e.g. 3:56)
get_ttime() {
    len=$(@playerctl@ metadata mpris:length 2>/dev/null)
    if [[ -z "$len" ]]; then
        echo "0:00"
    else
        len_sec=$(echo "$len / 1000000" | @bc@)
        date -u -d @"$len_sec" +%M:%S
    fi
}

## Get cover
get_cover() {
    arturl=$(@playerctl@ metadata mpris:artUrl 2>/dev/null)
    if [[ -n "$arturl" && "$arturl" =~ ^file:// ]]; then
        cover_path="${arturl#file://}"
        cp "$cover_path" "$COVER" 2>/dev/null && echo "$COVER" && return
    fi
    echo "$DEFAULT_COVER"
}

## Execute accordingly
case "$1" in
    --song) get_song ;;
    --artist) get_artist ;;
    --status) get_status ;;
    --time) get_time ;;
    --ctime) get_ctime ;;
    --ttime) get_ttime ;;
    --cover) get_cover ;;
    --toggle) @playerctl@ play-pause ;;
    --next) @playerctl@ next && get_cover ;;
    --prev) @playerctl@ previous && get_cover ;;
esac

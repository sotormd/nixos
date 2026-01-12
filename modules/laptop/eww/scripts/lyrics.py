#!/usr/bin/env @python3@

import os
import re
import subprocess

import syncedlyrics

CACHE_DIR = os.path.expanduser("~/.cache/lyrics")
os.makedirs(CACHE_DIR, exist_ok=True)


def parse_lyrics(lyrics_text):
    parsed = {}
    timestamps = []
    for line in lyrics_text.splitlines():
        line = line.strip()
        match = re.match(r"\[(\d{2}:\d{2}\.\d{2})\](.+)", line)
        if match:
            ts, text = match.groups()
            minutes, seconds = ts.split(":")
            sec, _ = seconds.split(".")
            t = int(minutes) * 60 + int(sec)
            parsed[t] = text.strip()
            timestamps.append(t)
    return parsed, timestamps


def find_current_index(progress, timestamps):
    for i, t in enumerate(timestamps):
        if t > progress:
            return max(0, i - 1)
    return len(timestamps) - 1 if timestamps else -1


def get_current_track():
    try:
        artist = subprocess.check_output(
            ["@playerctl@", "metadata", "artist"], text=True
        ).strip()
        title = subprocess.check_output(
            ["@playerctl@", "metadata", "title"], text=True
        ).strip()
        progress = float(
            subprocess.check_output(["@playerctl@", "position"], text=True).strip()
        )
        return {"artist": artist, "title": title, "progress": progress}
    except subprocess.CalledProcessError:
        return None


track_info = get_current_track()
if not track_info:
    exit(0)

artist = track_info["artist"]
title = track_info["title"]
progress = track_info["progress"]

# cache key
key = f"{artist} – {title}".replace("/", "_")
cache_file = os.path.join(CACHE_DIR, key + ".txt")

# fetch or load lyrics
if os.path.exists(cache_file):
    with open(cache_file, "r", encoding="utf-8") as f:
        lyrics = f.read()
else:
    lyrics = syncedlyrics.search(f"{title} {artist}") or ""
    if lyrics:
        with open(cache_file, "w", encoding="utf-8") as f:
            f.write(lyrics)

if not lyrics:
    exit(0)

parsed_lyrics, lyric_times = parse_lyrics(lyrics)
if not lyric_times:
    exit(0)

idx = find_current_index(progress, lyric_times)

# previous two lines
# if idx-2 >= 0:
# print(parsed_lyrics[lyric_times[idx-2]])
if idx - 1 >= 0:
    print(parsed_lyrics[lyric_times[idx - 1]][:75])
else:
    print()

# current line
print(parsed_lyrics[lyric_times[idx]][:75])

# next two lines
if idx + 1 < len(lyric_times):
    print(parsed_lyrics[lyric_times[idx + 1]][:75])
else:
    print()
if idx + 2 < len(lyric_times):
    print(parsed_lyrics[lyric_times[idx + 2]][:75])

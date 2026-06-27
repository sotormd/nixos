{
  brightnessctl,
  dunst,
  gawk,
  playerctl,
  python3,
  wireplumber,
  runtimeShell,
  writeTextFile,
  ...
}:

let
  volume = writeTextFile {
    name = "dunst-scripts-volume";
    text = ''
      #!${runtimeShell}

      # change this to +5% or -5% when binding keys
      change="$1"

      # apply volume change
      ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ "$change"

      # get current volume as 0–100 integer
      vol=$(${wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${gawk}/bin/awk '{printf "%d", $2 * 100}')

      # show dunst progress bar
      ${dunst}/bin/dunstify -a "volume" -r 9999 "Volume: $vol%" -h int:value:"$vol" -t 1500
    '';
    destination = "/bin/volume";
    executable = true;
  };

  brightness = writeTextFile {
    name = "dunst-scripts-brightness";
    text = ''
      #!${runtimeShell}

      change="$1"

      # Apply brightness change
      ${brightnessctl}/bin/brightnessctl set "$change"

      # Compute % value
      lvl=$(${brightnessctl}/bin/brightnessctl g)
      max=$(${brightnessctl}/bin/brightnessctl m)
      pct=$(( lvl * 100 / max ))

      # Send dunst progress bar
      ${dunst}/bin/dunstify -a "brightness" -r 9998 "Brightness: $pct%" -h int:value:"$pct" -t 1500
    '';
    destination = "/bin/brightness";
    executable = true;
  };

  media = writeTextFile {
    name = "dunst-scripts-media";
    text = ''
      #!${python3.withPackages (ps: with ps; [ syncedlyrics ])}/bin/python3

      import argparse
      import html
      import json
      import os
      import re
      import subprocess
      import syncedlyrics
      import sys

      PLAYERCTL="${playerctl}/bin/playerctl"
      TIMEOUT = 0.25
      RETRY_COUNT = 3
      RUNTIME = os.environ.get("XDG_RUNTIME_DIR", "/tmp")
      HOME = os.environ.get("HOME", "/tmp")
      ANIMATION_FILE = os.path.join(RUNTIME, "waybar-noanimation")
      DEFAULT_ART = "${../eww/default-album-art.png}"
      BRAVE_TMP = os.path.join(RUNTIME, "bubblewrap-brave-tmp")
      LYRICS_CACHE = os.path.join(HOME, ".cache", "lyrics")


      def __safe_run(cmd: list):
          for _ in range(RETRY_COUNT):
              try:
                  return subprocess.check_output(cmd, text=True, timeout=TIMEOUT).strip()
              except subprocess.TimeoutExpired:
                  continue
              except subprocess.CalledProcessError:
                  break
              except Exception as _:
                  break
          return ""


      def __escape_html(s: str) -> str:
          return html.escape(s, quote=True)


      def __clean_title(title: str) -> str:
          title = title.split(" -")[0]
          title = re.sub(r"\(.*?\)|\[.*?\]", "", title)
          return title.strip()


      def __clean_artist(artist: str) -> str:
          parts = [a.strip() for a in artist.split(",")]
          artist = ", ".join(parts[:2])
          return artist.strip()


      def __parse_lyrics(lyrics_text: str) -> tuple:
          parsed = {}
          timestamps = []
          for line in lyrics_text.splitlines():
              line = line.strip()
              match = re.match(r"\[(\d{2}:\d{2}\.\d{2})\](.+)", line)
              if match:
                  ts, text = match.groups()
                  minutes, seconds = ts.split(":")
                  sec, _ = seconds.split(".")
                  t = int(minutes)*60 + int(sec)
                  parsed[t] = text.strip()
                  timestamps.append(t)
          return parsed, timestamps


      def __find_current_index(position: int, timestamps: list):
          for i, t in enumerate(timestamps):
              if t > position:
                  return max(0, i - 1)
          return len(timestamps) - 1 if timestamps else -1


      def __cache_lyrics(title: str, artist: str):
          os.makedirs(LYRICS_CACHE, exist_ok=True)
          key = f"{title} - {artist}".replace("/", "_")
          cache_file = os.path.join(LYRICS_CACHE, key + ".txt")
          if os.path.exists(cache_file):
              with open(cache_file, "r", encoding="utf-8") as f:
                  lyrics = f.read()
          else:
              lyrics = syncedlyrics.search(f"{title} {artist}") or ""
              if lyrics:
                  with open(cache_file, "w", encoding="utf-8") as f:
                      f.write(lyrics)

          return lyrics


      def __waybar_metadata() -> tuple:
          out = __safe_run([
              PLAYERCTL,
              "metadata",
              "--format",
              "{{status}}|{{xesam:title}}|{{xesam:artist}}"
          ])
          if not out:
              return "", "", ""

          status, title, artist = (out.split("|", 2) + ["", "", ""])[:3]
          return status, __clean_title(title), __clean_artist(artist)


      def __lyrics_metadata() -> tuple:
          out = __safe_run([
              PLAYERCTL,
              "metadata",
              "--format",
              "{{status}}|{{xesam:title}}|{{xesam:artist}}|{{position}}"
          ])
          if not out:
              return "", "", "", ""

          status, title, artist, position = (out.split("|", 3) + ["", "", "", ""])[:4]
          try:
              position = int(position) / 1000000
          except ValueError:
              return "", "", "", ""

          return status, title, artist, position


      def post_previous():
          __safe_run([PLAYERCTL, "previous"])


      def post_play_pause():
          __safe_run([PLAYERCTL, "play-pause"])


      def post_next():
          __safe_run([PLAYERCTL, "next"])


      def post_stop():
          __safe_run([PLAYERCTL, "stop"])


      def get_eww_title() -> str:
          title = __clean_title(__safe_run([PLAYERCTL, "metadata", "xesam:title"]))
          if not title:
              return "Play some music!"
          return title


      def get_eww_artist() -> str:
          artist = __clean_artist(__safe_run([PLAYERCTL, "metadata", "xesam:artist"]))
          if not artist:
              return "-"
          return artist


      def get_eww_status() -> str:
          status = __safe_run([PLAYERCTL, "status"])
          match status:
              case "Playing":
                  icon = ""
              case "Paused":
                  icon = ""
              case "Stopped":
                  icon = ""
              case _:
                  icon = ""
          return icon


      def get_eww_perc() -> int:
          position = __safe_run([PLAYERCTL, "position"])
          length = __safe_run([PLAYERCTL, "metadata", "mpris:length"])

          if not length or not position:
              return 0

          try:
            position = float(position)
            length = int(length) / 1000000
          except ValueError:
              return 0

          if length <= 0:
              return 0

          return int(100*position/length)


      def get_eww_art() -> str:
          out = __safe_run([
              PLAYERCTL,
              "metadata",
              "--format",
              "{{mpris:artUrl}}|{{mpris:trackid}}"
          ])
          if not out:
              return DEFAULT_ART

          art, player = (out.split("|", 1) + ["", ""])[:2]

          if not art.startswith("file://"):
              return DEFAULT_ART

          art = art.removeprefix("file://")

          # for bubblewrapped brave
          if "/com/brave/MediaPlayer2/" in player and art.startswith("/tmp"):
              art = art.replace("/tmp", BRAVE_TMP, 1)

          return art


      def get_waybar_json() -> str:
          status, title, artist = __waybar_metadata()
          match status:
              case "Playing":
                  icon = ""
                  if os.path.exists(ANIMATION_FILE):
                      cls = "playerctl-playing-noanimation"
                  else:
                      cls = "playerctl-playing"
              case "Paused":
                  icon = ""
                  cls = "playerctl-paused"
              case "Stopped":
                  return ""
              case _:
                  return ""

          if not title or not artist:
            return ""

          result = {
              "text": f"<span size='10000'>{icon}</span> {__escape_html(title)} - {__escape_html(artist)}",
              "class": cls,
          }

          return json.dumps(result)


      def get_lyrics():
          status, title, artist, position = __lyrics_metadata()
          if status not in ("Playing", "Paused"):
              return ""
          if not title or not artist:
              return ""

          lyrics = __cache_lyrics(title, artist)
          if not lyrics:
              return ""

          parsed_lyrics, lyric_times = __parse_lyrics(lyrics)
          if not lyric_times:
              return ""

          idx = __find_current_index(position, lyric_times)
          if idx < 0:
              return ""

          # 1 previous line
          if idx-1 >= 0:
              print(parsed_lyrics[lyric_times[idx-1]][:75])
          else:
              print()

          # current line
          print(parsed_lyrics[lyric_times[idx]][:75])

          # 2 next lines
          if idx+1 < len(lyric_times):
              print(parsed_lyrics[lyric_times[idx+1]][:75])
          else:
              print()
          if idx+2 < len(lyric_times):
              print(parsed_lyrics[lyric_times[idx+2]][:75])
          else:
              print()


      if __name__ == "__main__":
          parser = argparse.ArgumentParser(description="safe, usable playerctl interface")
          parser.add_argument("verb")
          args = parser.parse_args()

          verb = args.verb

          try:
              match verb:
                  case "previous":
                      post_previous()
                  case "play-pause":
                      post_play_pause()
                  case "next":
                      post_next()
                  case "stop":
                      post_stop()
                  case "status":
                      print(get_eww_status())
                  case "title":
                      print(get_eww_title())
                  case "artist":
                      print(get_eww_artist())
                  case "perc":
                      print(get_eww_perc())
                  case "art":
                      print(get_eww_art())
                  case "waybar":
                      print(get_waybar_json())
                  case "lyrics":
                      get_lyrics()
                  case _:
                      sys.exit(1)
          except Exception as _:  # dont want it to crash
              pass
    '';
    destination = "/bin/media";
    executable = true;
  };
in
{
  inherit volume brightness media;
}

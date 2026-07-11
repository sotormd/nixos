{
  brightnessctl,
  dunst0,
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
      ${dunst0}/bin/dunstify -a "volume" -r 9999 "Volume: $vol%" -h int:value:"$vol" -t 1500
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
      ${dunst0}/bin/dunstify -a "brightness" -r 9998 "Brightness: $pct%" -h int:value:"$pct" -t 1500
    '';
    destination = "/bin/brightness";
    executable = true;
  };

  media = writeTextFile {
    name = "dunst-scripts-media";
    text = ''
      #!${python3}/bin/python3

      import argparse
      import subprocess
      import sys

      PLAYERCTL="${playerctl}/bin/playerctl"
      TIMEOUT = 0.25
      RETRY_COUNT = 3


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


      def post_previous():
          __safe_run([PLAYERCTL, "previous"])


      def post_play_pause():
          __safe_run([PLAYERCTL, "play-pause"])


      def post_next():
          __safe_run([PLAYERCTL, "next"])


      def post_stop():
          __safe_run([PLAYERCTL, "stop"])


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

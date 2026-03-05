{ pkgs, ... }:

let
  volume = pkgs.writeTextFile {
    name = "dunst-scripts-volume";
    text = ''
      #!${pkgs.runtimeShell}

      # change this to +5% or -5% when binding keys
      change="$1"

      # apply volume change
      ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ "$change"

      # get current volume as 0–100 integer
      vol=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gawk}/bin/awk '{printf "%d", $2 * 100}')

      # show dunst progress bar
      ${pkgs.dunst}/bin/dunstify -a "volume" -r 9999 "Volume: $vol%" -h int:value:"$vol" -t 1500
    '';
    destination = "/bin/volume";
    executable = true;
  };

  brightness = pkgs.writeTextFile {
    name = "dunst-scripts-brightness";
    text = ''
      #!${pkgs.runtimeShell}

      change="$1"

      # Apply brightness change
      ${pkgs.brightnessctl}/bin/brightnessctl set "$change"

      # Compute % value
      lvl=$(${pkgs.brightnessctl}/bin/brightnessctl g)
      max=$(${pkgs.brightnessctl}/bin/brightnessctl m)
      pct=$(( lvl * 100 / max ))

      # Send dunst progress bar
      ${pkgs.dunst}/bin/dunstify -a "brightness" -r 9998 "Brightness: $pct%" -h int:value:"$pct" -t 1500
    '';
    destination = "/bin/brightness";
    executable = true;
  };
in
{
  inherit volume brightness;
}

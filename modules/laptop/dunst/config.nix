{ pkgs, colors, ... }:

let
  config = pkgs.writeTextFile {
    name = "dunstrc";
    text = ''
      [global]
      background="#${colors.bg0}"
      corner_radius=7
      font="IBM Plex Sans 9"
      frame_color="#${colors.blue2}"
      gap_size=5
      monitor=1
      offset="5x5"
      origin="top-right"

      [urgency_critical]
      frame_color="#${colors.yellow}"
    '';
    destination = "/dunstrc";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "dunst";
    paths = [ config ];
  };
}

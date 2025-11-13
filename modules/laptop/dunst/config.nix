{
  pkgs,
  colors,
  vars,
  ...
}:

let
  config = pkgs.writeTextFile {
    name = "dunstrc";
    text = ''
      [global]
      background="#${colors.bg0}"
      corner_radius=7
      font="${colors.fonts.normal} 9"
      frame_color="#${colors.blue2}"
      gap_size=5
      monitor=${vars.outputs.monitor}
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

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
      background="#${colors.dunst.bg}"
      corner_radius=7
      font="${colors.fonts.normal} 9"
      frame_color="#${colors.dunst.normal}"
      gap_size=5
      monitor=${vars.outputs.monitor}
      offset="5x5"
      origin="top-right"
      highlight="#${colors.dunst.normal}"

      [urgency_critical]
      frame_color="#${colors.dunst.urgent}"
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

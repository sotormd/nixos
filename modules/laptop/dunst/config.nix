{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "dunstrc";
    text = ''
      [global]
      background="#${config.colors.dunst.bg}"
      corner_radius=7
      font="${config.colors.fonts.normal} 9"
      frame_color="#${config.colors.dunst.normal}"
      gap_size=5
      monitor=${config.vars.outputs.monitor}
      offset="5x5"
      origin="top-right"
      highlight="#${config.colors.dunst.normal}"

      [urgency_critical]
      frame_color="#${config.colors.dunst.urgent}"
    '';
    destination = "/dunstrc";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "dunst";
    paths = [ configuration ];
  };
}

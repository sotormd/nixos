{ config, pkgs, ... }:

let
  configuration = pkgs.writeTextFile {
    name = "dunst-dunstrc";
    text = ''
      [global]
      background="#${config.colors.dunst.bg}"
      corner_radius=7
      font="${config.colors.fonts.normal} 9"
      frame_color="#${config.colors.dunst.normal}"
      gap_size=5
      monitor=${config.vars.displays.outputs.${config.vars.displays.primary}.identifier}
      offset="5x5"
      origin="top-right"
      highlight="#${config.colors.dunst.normal}"

      [urgency_critical]
      frame_color="#${config.colors.dunst.urgent}"
    '';
    destination = "/dunstrc";
    executable = false;
  };
in
{
  inherit configuration;
}

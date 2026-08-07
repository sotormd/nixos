{
  lib,
  writeTextFile,
  vars,
  ...
}:

let
  inherit (lib) colors;

  configuration = writeTextFile {
    name = "dunst-dunstrc";
    text = ''
      [global]
      background="#${colors.dunst.bg}"
      font="${colors.fonts.normal} 9"
      frame_color="#${colors.dunst.normal}"
      gap_size=5
      monitor=${vars.displays.outputs.${vars.displays.primary}.identifier}
      offset="5x5"
      origin="top-right"
      highlight="#${colors.dunst.normal}"

      [urgency_critical]
      frame_color="#${colors.dunst.urgent}"
    '';
    destination = "/dunstrc";
    executable = false;
  };
in
configuration

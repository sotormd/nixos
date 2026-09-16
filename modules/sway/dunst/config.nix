{
  lib,
  writeText,
  vars,
}:

let
  inherit (lib) colors;

  configuration = writeText "dunst-configuration" ''
    [global]
    background="#${colors.dunst.bg}"
    font="${colors.fonts.normal} 9"
    frame_color="#${colors.dunst.normal}"
    gap_size=5
    monitor=${vars.displays.outputs.${vars.displays.primary}.identifier}
    offset="6x6"
    origin="top-right"
    highlight="#${colors.dunst.normal}"

    [urgency_critical]
    frame_color="#${colors.dunst.urgent}"
  '';
in
configuration

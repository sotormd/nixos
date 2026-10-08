{ lib, writeText }:

let
  inherit (lib) colors;

  configuration = writeText "settings.conf" ''
    [org/xfce/mousepad/preferences/window]
    menubar-visible=false

    [org/xfce/mousepad/preferences/view]
    use-default-monospace-font=false
    font-name='${colors.fonts.monospace} 10'
  '';
in
configuration

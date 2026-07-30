{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) colors;

  user = config.vars.user.name;
  home = "/home/${user}";

  settings = pkgs.writeText "settings.conf" ''
    [org/xfce/mousepad/preferences/window]
    menubar-visible=false

    [org/xfce/mousepad/preferences/view]
    use-default-monospace-font=false
    font-name='${colors.fonts.monospace} 10'
  '';
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.config 0700 ${user} ${user} -"
    "d ${home}/.config/Mousepad 0700 ${user} ${user} -"
    "L ${home}/.config/Mousepad/settings.conf - - - - ${settings}"
    "Z ${home}/.config/Mousepad/settings.conf - ${user} ${user} -"
  ];
}

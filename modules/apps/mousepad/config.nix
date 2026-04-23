{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  settings = pkgs.writeText "settings.conf" ''
    [org/xfce/mousepad/preferences/window]
    menubar-visible=false

    [org/xfce/mousepad/preferences/view]
    use-default-monospace-font=false
    font-name='${config.colors.fonts.monospace} 10'
  '';
in
{
  systemd.tmpfiles.rules = [
    "L ${home}/.config/Mousepad/settings.conf - - - - ${settings}"
  ];
}

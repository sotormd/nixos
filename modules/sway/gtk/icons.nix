{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  icon = "${pkgs.${config.colors.gtk.icons.package}}/share/icons/${config.colors.gtk.icons.name}";
in
{
  systemd.tmpfiles.rules = [
    "L ${home}/.local/share/icons/${config.colors.gtk.icons.name} - - - - ${icon}"
  ];
}

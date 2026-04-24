{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  icon = "${pkgs.${config.colors.gtk.icons.package}}/share/icons/${config.colors.gtk.icons.name}";
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
    "d  ${home}/.local/share/icons 0700 ${user} ${user} -"
    "L ${home}/.local/share/icons/${config.colors.gtk.icons.name} - - - - ${icon}"
  ];
}

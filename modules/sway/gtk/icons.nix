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

  icon = "${pkgs.${colors.gtk.icons.package}}/share/icons/${colors.gtk.icons.name}";
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
    "d  ${home}/.local/share/icons 0700 ${user} ${user} -"
    "L ${home}/.local/share/icons/${colors.gtk.icons.name} - - - - ${icon}"
    "Z ${home}/.local/share/icons/${colors.gtk.icons.name} - ${user} ${user} -"
  ];
}

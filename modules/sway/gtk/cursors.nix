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

  cursors = "${pkgs.${colors.gtk.cursor.package}}/share/icons/${colors.gtk.cursor.name}";

  index = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${colors.gtk.cursor.name}
  '';

  Xresources = pkgs.writeText ".Xresources" ''
    Xcursor.size: 1
    Xcursor.theme: ${colors.gtk.cursor.name}
  '';
in
{
  systemd.tmpfiles.rules = [
    "L ${home}/.Xresources - - - - ${Xresources}"
    "Z ${home}/.Xresources - ${user} ${user} -"
    "d ${home}/.icons 0700 ${user} ${user} -"
    "L ${home}/.icons/${colors.gtk.cursor.name} - - - - ${cursors}"
    "Z ${home}/.icons/${colors.gtk.cursor.name} - ${user} ${user} -"
    "d ${home}/.icons/default 0700 ${user} ${user} -"
    "L ${home}/.icons/default/index.theme - - - - ${index}"
    "Z ${home}/.icons/default/index.theme - ${user} ${user} -"
  ];
}

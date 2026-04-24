{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  cursors = "${
    pkgs.${config.colors.gtk.cursor.package}
  }/share/icons/${config.colors.gtk.cursor.name}";

  index = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${config.colors.gtk.cursor.name}
  '';

  Xresources = pkgs.writeText ".Xresources" ''
    Xcursor.size: 1
    Xcursor.theme: ${config.colors.gtk.cursor.name}
  '';
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.icons 0700 ${user} ${user} -"
    "L ${home}/.icons/${config.colors.gtk.cursor.name} - - - - ${cursors}"
    "d ${home}/.icons/default 0700 ${user} ${user} -"
    "L ${home}/.icons/default/index.theme - - - - ${index}"
    "L ${home}/.Xresources - - - - ${Xresources}"
  ];
}

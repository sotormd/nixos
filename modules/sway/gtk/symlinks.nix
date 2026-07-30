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

  gtk2 = pkgs.writeText ".gtkrc-2.0" ''
    gtk-cursor-theme-name = "${colors.gtk.cursor.name}"
    gtk-cursor-theme-size = 1
    gtk-font-name = "${colors.fonts.normal} 10"
    gtk-icon-theme-name = "${colors.gtk.icons.name}"
    gtk-theme-name = "${colors.gtk.theme.name}"
  '';
  gtk3 = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-cursor-theme-name=${colors.gtk.cursor.name}
    gtk-cursor-theme-size=1
    gtk-font-name=${colors.fonts.normal} 10
    gtk-icon-theme-name=${colors.gtk.icons.name}
    gtk-theme-name=${colors.gtk.theme.name}
  '';
  gtk4 = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-cursor-theme-name=${colors.gtk.cursor.name}
    gtk-cursor-theme-size=1
    gtk-font-name=${colors.fonts.normal} 10
    gtk-icon-theme-name=${colors.gtk.icons.name}
    gtk-theme-name=${colors.gtk.theme.name}
  '';
in
{
  systemd.tmpfiles.rules = [
    "L ${home}/.gtkrc-2.0 - - - - ${gtk2}"
    "Z ${home}/.gtkrc-2.0 - ${user} ${user} -"
    "d ${home}/.config 0700 ${user} ${user} -"
    "d ${home}/.config/gtk-3.0 0700 ${user} ${user} -"
    "L ${home}/.config/gtk-3.0/settings.ini - - - - ${gtk3}"
    "Z ${home}/.config/gtk-3.0/settings.ini - ${user} ${user} -"
    "d ${home}/.config/gtk-4.0 0700 ${user} ${user} -"
    "L ${home}/.config/gtk-4.0/settings.ini - - - - ${gtk4}"
    "Z ${home}/.config/gtk-4.0/settings.ini - ${user} ${user} -"
  ];
}

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

  theme = "${pkgs.${colors.gtk.theme.package}}/share/themes/${colors.gtk.theme.name}";
  css = pkgs.writeText "gtk.css" ''
    /**
     * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
     * It does however respect user CSS, so import the theme from here.
    **/
    @import url("file://${
      pkgs.${colors.gtk.theme.package}
    }/share/themes/${colors.gtk.theme.name}/gtk-4.0/gtk.css");
  '';
in
{
  systemd.tmpfiles.rules = [
    "d ${home}/.local 0700 ${user} ${user} -"
    "d ${home}/.local/share 0700 ${user} ${user} -"
    "d ${home}/.local/share/themes 0700 ${user} ${user} -"
    "L ${home}/.local/share/themes/${colors.gtk.theme.name} - - - - ${theme}"
    "Z ${home}/.local/share/themes/${colors.gtk.theme.name} - ${user} ${user} -"
    "d ${home}/.config/gtk-4.0 0700 ${user} ${user} -"
    "L ${home}/.config/gtk-4.0/gtk.css - - - - ${css}"
    "Z ${home}/.config/gtk-4.0/gtk.css - ${user} ${user} -"
  ];
}

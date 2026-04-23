{ config, pkgs, ... }:

let
  user = config.vars.user.name;
  home = "/home/${user}";

  theme = "${pkgs.${config.colors.gtk.theme.package}}/share/themes/${config.colors.gtk.theme.name}";
  css = pkgs.writeText "gtk.css" ''
    /**
     * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
     * It does however respect user CSS, so import the theme from here.
    **/
    @import url("file://${
      pkgs.${config.colors.gtk.theme.package}
    }/share/themes/${config.colors.gtk.theme.name}/gtk-4.0/gtk.css");
  '';
in
{
  systemd.tmpfiles.rules = [
    "L ${home}/.local/share/themes/${config.colors.gtk.theme.name} - - - - ${theme}"
    "L ${home}/.config/gtk-4.0/gtk.css - - - - ${css}"
  ];
}

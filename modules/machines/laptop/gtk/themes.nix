{ config, pkgs, ... }:

{
  hjem.users.${config.vars.user.name}.files = {
    ".local/share/themes/${config.colors.gtk.theme.name}".source = "${
      pkgs.${config.colors.gtk.theme.package}
    }/share/themes/${config.colors.gtk.theme.name}";

    ".config/gtk-4.0/gtk.css".text = ''
      /**
       * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
       * It does however respect user CSS, so import the theme from here.
      **/
      @import url("file://${
        pkgs.${config.colors.gtk.theme.package}
      }/share/themes/${config.colors.gtk.theme.name}/gtk-4.0/gtk.css");
    '';
  };
}

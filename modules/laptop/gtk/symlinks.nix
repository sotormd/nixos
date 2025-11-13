{
  pkgs,
  colors,
  vars,
  ...
}:

{
  hjem.users.${vars.user.name} = {
    files = {
      ".local/share/themes/${colors.gtk.theme.name}".source = "${
        pkgs.${colors.gtk.theme.package}
      }/share/themes/${colors.gtk.theme.name}";

      ".local/share/icons/${colors.gtk.icons.name}".source = "${
        pkgs.${colors.gtk.icons.package}
      }/share/icons/${colors.gtk.icons.name}";

      ".icons/${colors.gtk.cursor.name}".source = "${
        pkgs.${colors.gtk.cursor.package}
      }/share/icons/${colors.gtk.cursor.name}";

      ".icons/default/index.theme".text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${colors.gtk.cursor.name}
      '';

      ".Xresources".text = ''
        Xcursor.size: 1
        Xcursor.theme: ${colors.gtk.cursor.name}
      '';

      ".gtkrc-2.0".text = ''
        gtk-cursor-theme-name = "${colors.gtk.cursor.name}"
        gtk-cursor-theme-size = 1
        gtk-font-name = "${colors.fonts.normal} 10"
        gtk-icon-theme-name = "${colors.gtk.icons.name}"
        gtk-theme-name = "${colors.gtk.theme.name}"
      '';

      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${colors.gtk.cursor.name}
        gtk-cursor-theme-size=1
        gtk-font-name=${colors.fonts.normal} 10
        gtk-icon-theme-name=${colors.gtk.icons.name}
        gtk-theme-name=${colors.gtk.theme.name}
      '';

      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${colors.gtk.cursor.name}
        gtk-cursor-theme-size=1
        gtk-font-name=${colors.fonts.normal} 10
        gtk-icon-theme-name=${colors.gtk.icons.name}
        gtk-theme-name=${colors.gtk.theme.name}
      '';

      ".config/gtk-4.0/gtk.css".text = ''
        /**
         * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
         * It does however respect user CSS, so import the theme from here.
        **/
        @import url("file://${
          pkgs.${colors.gtk.theme.package}
        }/share/themes/${colors.gtk.theme.name}/gtk-4.0/gtk.css");
      '';
    }
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/${pkg}";
        value.source = "${pkgs.${pkg}}/share/fonts";
      }) colors.fonts.packages
    )
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/nerdfonts/${pkg}";
        value.source = "${pkgs.nerd-fonts.${pkg}}/share/fonts";
      }) colors.fonts.nerdfonts
    );
  };
}

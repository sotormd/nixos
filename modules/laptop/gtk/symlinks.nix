{
  config,
  pkgs,
  vars,
  ...
}:

{
  hjem.users.${vars.user.name} = {
    files = {
      ".local/share/themes/${config.colors.gtk.theme.name}".source = "${
        pkgs.${config.colors.gtk.theme.package}
      }/share/themes/${config.colors.gtk.theme.name}";

      ".local/share/icons/${config.colors.gtk.icons.name}".source = "${
        pkgs.${config.colors.gtk.icons.package}
      }/share/icons/${config.colors.gtk.icons.name}";

      ".icons/${config.colors.gtk.cursor.name}".source = "${
        pkgs.${config.colors.gtk.cursor.package}
      }/share/icons/${config.colors.gtk.cursor.name}";

      ".icons/default/index.theme".text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${config.colors.gtk.cursor.name}
      '';

      ".Xresources".text = ''
        Xcursor.size: 1
        Xcursor.theme: ${config.colors.gtk.cursor.name}
      '';

      ".gtkrc-2.0".text = ''
        gtk-cursor-theme-name = "${config.colors.gtk.cursor.name}"
        gtk-cursor-theme-size = 1
        gtk-font-name = "${config.colors.fonts.normal} 10"
        gtk-icon-theme-name = "${config.colors.gtk.icons.name}"
        gtk-theme-name = "${config.colors.gtk.theme.name}"
      '';

      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${config.colors.gtk.cursor.name}
        gtk-cursor-theme-size=1
        gtk-font-name=${config.colors.fonts.normal} 10
        gtk-icon-theme-name=${config.colors.gtk.icons.name}
        gtk-theme-name=${config.colors.gtk.theme.name}
      '';

      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=${config.colors.gtk.cursor.name}
        gtk-cursor-theme-size=1
        gtk-font-name=${config.colors.fonts.normal} 10
        gtk-icon-theme-name=${config.colors.gtk.icons.name}
        gtk-theme-name=${config.colors.gtk.theme.name}
      '';

      ".config/gtk-4.0/gtk.css".text = ''
        /**
         * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
         * It does however respect user CSS, so import the theme from here.
        **/
        @import url("file://${
          pkgs.${config.colors.gtk.theme.package}
        }/share/themes/${config.colors.gtk.theme.name}/gtk-4.0/gtk.css");
      '';
    }
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/${pkg}";
        value.source = "${pkgs.${pkg}}/share/fonts";
      }) config.colors.fonts.packages
    )
    // builtins.listToAttrs (
      map (pkg: {
        name = ".local/share/fonts/nerdfonts/${pkg}";
        value.source = "${pkgs.nerd-fonts.${pkg}}/share/fonts";
      }) config.colors.fonts.nerdfonts
    );
  };
}

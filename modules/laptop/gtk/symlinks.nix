{ config, vars, ... }:

{
  hjem.users.${vars.user.name}.files = {
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
  };
}

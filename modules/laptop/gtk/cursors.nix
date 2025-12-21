{
  config,
  pkgs,
  vars,
  ...
}:

{
  hjem.users.${vars.user.name}.files = {
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
  };
}

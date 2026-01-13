{
  config,
  pkgs,
  vars,
  ...
}:

{
  hjem.users.${vars.user.name} = {
    files.".config/inkscape/preferences.xml".source = pkgs.replaceVars ./config/preferences.xml {
      inkscapeVersion = "${pkgs.inkscape.version}";
      gtkIcons = "${config.colors.gtk.icons.name}";
      gtkTheme = "${config.colors.gtk.theme.name}";
      colorDark = "${config.colors.bg0}";
      colorLight = "${config.colors.bg3}";
    };
  };
}

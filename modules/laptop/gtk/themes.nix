{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    gtk.theme.package = pkgs.nordic;
    gtk.theme.name = "Nordic-darker";

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Nordic-darker";
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":";
      };
    };
  };
}

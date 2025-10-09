{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
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

    # symlink themes over to ensure they work inside firejail
    home.file.".local/share/themes/Nordic-darker".source = "${pkgs.nordic}/share/themes/Nordic-darker";
  };
}

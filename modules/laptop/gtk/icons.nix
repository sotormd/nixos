{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    gtk.iconTheme.package = pkgs.nordzy-icon-theme;
    gtk.iconTheme.name = "Nordzy-dark";

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Nordzy-dark";
      };
    };
  };
}

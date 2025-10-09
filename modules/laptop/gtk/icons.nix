{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    gtk.iconTheme.package = pkgs.nordzy-icon-theme;
    gtk.iconTheme.name = "Nordzy-dark";

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Nordzy-dark";
      };
    };

    # symlink icons over to ensure they work inside firejail
    home.file.".local/share/icons/Nordzy-dark".source =
      "${pkgs.nordzy-icon-theme}/share/icons/Nordzy-dark";
  };
}

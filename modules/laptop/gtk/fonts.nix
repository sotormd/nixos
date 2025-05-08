{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    gtk.font.package = pkgs.ibm-plex;
    gtk.font.name = "IBM Plex Sans";
    gtk.font.size = 10;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "IBM Plex Sans 10";
      };
    };

    home.packages = [
      pkgs.ibm-plex
      pkgs.nerd-fonts.im-writing
      pkgs.noto-fonts-color-emoji
    ];
  };
}

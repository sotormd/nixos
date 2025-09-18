{ pkgs, vars, ... }:

{
  imports = [
    ./cursors.nix

    ./fonts.nix

    ./icons.nix

    ./themes.nix
  ];
  home-manager.users."${vars.user.name}" = {
    # enable GTK+
    gtk.enable = true;

    # enable dconf
    dconf.enable = true;
    home.packages = [ pkgs.dconf ];
  };
}

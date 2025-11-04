{ pkgs, ... }:

{
  imports = [
    ./cursors.nix

    ./fonts.nix

    ./icons.nix

    ./themes.nix
  ];

  # enable GTK+
  gtk.enable = true;

  # enable dconf
  dconf.enable = true;
  home.packages = [ pkgs.dconf ];
}

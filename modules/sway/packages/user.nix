{ config, pkgs, ... }:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = [

    # audio visualizer
    pkgs.cava

    # wayland image viewer
    pkgs.swayimg

    # image manipulation
    pkgs.imagemagick

    # wayland clipboard
    pkgs.wl-clipboard

  ];
}

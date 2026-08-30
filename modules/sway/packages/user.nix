{ config, pkgs, ... }:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = [

    # wayland image viewer
    pkgs.swayimg

    # wayland clipboard
    pkgs.wl-clipboard

    # screen recorder
    pkgs.wf-recorder

  ];
}

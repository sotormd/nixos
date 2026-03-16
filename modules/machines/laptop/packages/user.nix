{
  config,
  inputs,
  pkgs,
  ...
}:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = [

    # audio visualizer
    pkgs.cava

    # compression
    pkgs.file-roller

    # wayland image viewer
    pkgs.swayimg

    # image manipulation
    pkgs.imagemagick

    # wayland clipboard
    pkgs.wl-clipboard

    # kiosk-style compositor
    pkgs.cage

    # dconf editor
    pkgs.dconf

    # sway idle daemon
    pkgs.swayidle

    # fortune cookies
    pkgs.fortune

    # remove file metadata
    pkgs.mat2

    # text editor
    inputs.neovim.packages.x86_64-linux.default

  ];
}

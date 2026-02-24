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

    # wayland clipboard
    pkgs.wl-clipboard

    # kiosk-style compositor
    pkgs.cage

    # text editor
    inputs.neovim.packages.x86_64-linux.default
  ];
}

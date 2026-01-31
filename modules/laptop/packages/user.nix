{
  config,
  inputs,
  pkgs,
  ...
}:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = with pkgs; [
    # audio visualizer
    cava

    # compression
    file-roller

    # wayland image viewer
    swayimg

    # wayland clipboard
    wl-clipboard

    # kiosk-style compositor
    cage

    # text editor
    inputs.neovim.packages.x86_64-linux.default
  ];
}

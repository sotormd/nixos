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

    # mpris control
    pkgs.playerctl

    # compression
    pkgs.file-roller

    # wayland image viewer
    pkgs.swayimg

    # image manipulation
    pkgs.imagemagick

    # screenshots
    pkgs.slurp
    pkgs.grim
    pkgs.sway-contrib.grimshot

    # wayland clipboard
    pkgs.wl-clipboard

    # kiosk-style compositor
    pkgs.cage

    # dconf editor
    pkgs.dconf

    # sway idle daemon
    pkgs.swayidle

    # clipboard history
    pkgs.cliphist

    # fortune cookies
    pkgs.fortune

    # text editor
    inputs.neovim.packages.x86_64-linux.default
  ];
}

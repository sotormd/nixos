{ pkgs, vars, ... }:

{
  # set of packages to appear in user environment
  users.users.${vars.user.name}.packages = with pkgs; [
    # audio visualizer
    cava

    # compression
    file-roller

    # wayland image viewer
    swayimg

    # wayland clipboard
    wl-clipboard
  ];
}

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    # set of packages to appear in user environment
    home.packages = with pkgs; [
      # audio visualizer
      cava

      # compression
      file-roller

      # notifications
      libnotify

      # wayland image viewer
      swayimg

      # wayland clipboard
      wl-clipboard
    ];
  };
}

{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    # set of packages to appear in user environment
    home.packages = with pkgs; [
      # audio visualizer
      cava

      # system information tool
      fastfetch

      # compression
      file-roller

      # resource monitor
      htop

      # notifications
      libnotify

      # text editor
      nano

      # wayland image viewer
      swayimg

      # list contents of directories in a tree-like format
      tree

      # wayland clipboard
      wl-clipboard
    ];
  };
}

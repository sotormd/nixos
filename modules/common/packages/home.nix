{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users.${vars.user.name} = {
    # set of packages to appear in user environment
    home.packages = with pkgs; [
      # version control
      git

      # resource monitor
      htop

      # text editor
      nano

      # fast incremental file transfer utility
      rsync

      # list contents of directories in a tree-like format
      tree
    ];
  };
}

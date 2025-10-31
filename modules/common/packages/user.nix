{ pkgs, vars, ... }:

{
  # set of packages to appear in user environment
  users.users.${vars.user.name}.packages = with pkgs; [
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
}

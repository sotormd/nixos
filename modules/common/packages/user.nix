{ config, pkgs, ... }:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = with pkgs; [
    # version control
    git

    # resource monitor
    htop

    # text editors
    nano
    vim

    # fast incremental file transfer utility
    rsync

    # list contents of directories in a tree-like format
    tree
  ];

  environment.sessionVariables.EDITOR = "vi";
}

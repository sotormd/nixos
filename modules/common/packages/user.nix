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

    # list contents of directories in a tree-like format
    tree
  ];

  environment.sessionVariables.EDITOR = "vi";
}

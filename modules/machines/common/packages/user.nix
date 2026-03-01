{ config, pkgs, ... }:

{
  # set of packages to appear in user environment
  users.users.${config.vars.user.name}.packages = [
    # version control
    pkgs.git

    # resource monitor
    pkgs.htop

    # text editors
    pkgs.nano
    pkgs.vim

    # list contents of directories in a tree-like format
    pkgs.tree
  ];

  environment.sessionVariables.EDITOR = "vi";
}

{ config, pkgs, ... }:

{
  imports = [
    ./actions.nix

    ./gvfs.nix

    ./tumbler.nix

    ./xfconf.nix
  ];

  users.users.${config.vars.user.name}.packages = [ pkgs.xfce.thunar ];
}

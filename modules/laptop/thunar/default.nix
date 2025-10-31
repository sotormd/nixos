{ pkgs, vars, ... }:

{
  imports = [
    ./actions.nix

    ./gvfs.nix

    ./tumbler.nix

    ./xfconf.nix
  ];

  users.users.${vars.user.name}.packages = [ pkgs.xfce.thunar ];
}

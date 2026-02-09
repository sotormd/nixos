{ config, pkgs, ... }:

{
  imports = [
    ./config.nix
  ];

  users.users.${config.vars.user.name}.packages = [ pkgs.mousepad ];
}

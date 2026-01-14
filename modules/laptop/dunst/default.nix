{ config, pkgs, ... }:

let
  package = import ./package.nix { inherit config pkgs; };
in
{
  imports = [
    ./scripts.nix
  ];

  users.users.${config.vars.user.name}.packages = [
    package.dunst
    pkgs.libnotify
  ];
}

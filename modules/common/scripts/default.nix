{ config, pkgs, ... }:

let
  package = import ./bin.nix { inherit pkgs; };
in
{
  imports = [
    ./dir.nix

    ./env.nix
  ];

  users.users.${config.vars.user.name}.packages = [ package.nixosWrapper ];
}

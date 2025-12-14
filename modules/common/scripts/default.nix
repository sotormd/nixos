{ pkgs, vars, ... }:

let
  package = import ./bin.nix { inherit pkgs; };
in
{
  imports = [
    ./dir.nix

    ./env.nix
  ];

  users.users.${vars.user.name}.packages = [ package.nixosWrapper ];
}

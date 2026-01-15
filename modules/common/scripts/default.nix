{ pkgs, ... }:

let
  package = import ./bin.nix { inherit pkgs; };
in
{
  imports = [
    ./dir.nix

    ./env.nix
  ];

  environment.systemPackages = [ package.nixosWrapper ];
}

{ pkgs, ... }:

let
  package = import ./bin.nix { inherit pkgs; };
in
{
  environment.systemPackages = [ package.nixosWrapper ];
}

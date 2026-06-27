{ pkgs, ... }:

let
  package = pkgs.callPackage ./bin.nix { };
in
{
  environment.systemPackages = [ package ];
}

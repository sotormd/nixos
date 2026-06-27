{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) colors wallpapers vars; };
  package = pkgs.callPackage ./package.nix { inherit configuration; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { sway0 = package; }) ];
}

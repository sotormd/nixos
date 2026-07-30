{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) vars; };
  style = pkgs.callPackage ./style.nix { };
  package = pkgs.callPackage ./package.nix { inherit configuration style; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { waybar0 = package; }) ];
}

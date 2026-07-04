{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) colors; };
  package = pkgs.callPackage ./package.nix {
    inherit configuration;
    inherit (config) colors;
  };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { foot0 = package; }) ];
}

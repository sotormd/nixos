{ config, pkgs, ... }:

let
  style = pkgs.callPackage ./style.nix { inherit (config) colors; };
  configuration = pkgs.callPackage ./config.nix { inherit style; };
  package = pkgs.callPackage ./package.nix { inherit configuration; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { rofi0 = package; }) ];
}

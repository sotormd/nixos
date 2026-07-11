{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { inherit (config) colors vars; };
  package = pkgs.callPackage ./package.nix { inherit configuration; };
in
{
  users.users.${config.vars.user.name}.packages = [
    package
    pkgs.libnotify
  ];
  nixpkgs.overlays = [ (_: _: { dunst0 = package; }) ];
}

{ config, pkgs, ... }:

let
  scripts = pkgs.callPackage ./scripts.nix { };
  style = pkgs.callPackage ./style.nix { inherit (config) colors; };
  configuration = pkgs.callPackage ./config.nix {
    inherit scripts style;
    inherit (config) vars;
  };
  package = pkgs.callPackage ./package.nix { inherit configuration scripts; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { eww0 = package; }) ];
}

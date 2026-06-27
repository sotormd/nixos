{ config, pkgs, ... }:

let
  scripts = pkgs.callPackage ./scripts.nix { };
  configuration = pkgs.callPackage ./config.nix {
    inherit scripts;
    inherit (config) vars;
  };
  style = pkgs.callPackage ./style.nix { inherit (config) colors; };
  package = pkgs.callPackage ./package.nix { inherit configuration style; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
  nixpkgs.overlays = [ (_: _: { waybar0 = package; }) ];
}

{ config, pkgs, ... }:

let
  zathurarc = pkgs.callPackage ./config.nix { inherit (config) colors; };
  package = pkgs.callPackage ./package.nix { inherit zathurarc; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

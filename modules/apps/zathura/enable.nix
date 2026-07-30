{ config, pkgs, ... }:

let
  zathurarc = pkgs.callPackage ./config.nix { };
  package = pkgs.callPackage ./package.nix { inherit zathurarc; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

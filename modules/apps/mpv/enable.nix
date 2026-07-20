{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { };
  scripts = pkgs.callPackage ./scripts.nix { };
  package = pkgs.callPackage ./package.nix { inherit configuration scripts; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

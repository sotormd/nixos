{ config, pkgs, ... }:

let
  preferences = pkgs.callPackage ./config.nix { };
  package = pkgs.callPackage ./package.nix { inherit preferences; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

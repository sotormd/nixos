{ config, pkgs, ... }:

let
  preferences = pkgs.callPackage ./config.nix { inherit (config) colors; };
  package = pkgs.callPackage ./package.nix { inherit preferences; };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

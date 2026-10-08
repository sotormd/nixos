{ config, pkgs, ... }:

let
  configuration = pkgs.callPackage ./config.nix { };
  package = pkgs.callPackage ./package.nix {
    inherit configuration;
    inherit (config) vars;
  };
in
{
  users.users.${config.vars.user.name}.packages = [ package ];
}

{ config, pkgs, ... }:

let
  package = import ./package.nix { inherit pkgs; };
in
{
  users.users.${config.vars.user.name}.packages = [ package.mpv ];
}

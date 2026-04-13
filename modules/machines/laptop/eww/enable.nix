{ config, pkgs, ... }:

let
  package = import ./package.nix { inherit config pkgs; };
in
{
  users.users.${config.vars.user.name}.packages = [ package.ewwWrapped ];
  nixpkgs.overlays = [ (_: _: { eww0 = package.ewwWrapped; }) ];
}

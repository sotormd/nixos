{
  config,
  lib,
  pkgs,
  ...
}:

let
  package = import ./package.nix { inherit config lib pkgs; };
in
{
  users.users.${config.vars.user.name}.packages = [ package.swayWrapped ];
  nixpkgs.overlays = [ (_: _: { sway0 = package.swayWrapped; }) ];
}

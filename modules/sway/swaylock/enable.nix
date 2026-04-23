{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  package = import ./package.nix { inherit config lib pkgs; };
  xkcd = import ./xkcd.nix { inherit config inputs pkgs; };
in
{
  users.users.${config.vars.user.name}.packages = [
    package.swaylockWrapped
    xkcd.xkcdWrapped
  ];
  nixpkgs.overlays = [
    (_: _: { swaylock0 = package.swaylockWrapped; })
    (_: _: { xkcd0 = xkcd.xkcdWrapped; })
  ];
}

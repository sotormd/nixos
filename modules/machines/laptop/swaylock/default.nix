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
  imports = [
    ./settings.nix
  ];

  users.users.${config.vars.user.name}.packages = [
    package.swaylockWrapped
    xkcd.xkcdWrapped
  ];
}

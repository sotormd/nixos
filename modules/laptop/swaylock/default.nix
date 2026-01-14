{
  config,
  lib,
  pkgs,
  ...
}:

let
  package = import ./package.nix {
    inherit
      config
      lib
      pkgs
      ;
  };
in
{
  imports = [
    ./settings.nix

    ./xkcd.nix
  ];

  users.users.${config.vars.user.name}.packages = [ package.swaylock ];
}

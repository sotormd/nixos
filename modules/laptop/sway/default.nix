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

    ./start.nix
  ];

  users.users.${config.vars.user.name}.packages = [ package.sway ];
}

{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  package = import ./package.nix {
    inherit
      config
      lib
      pkgs
      vars
      ;
  };
in
{
  imports = [
    ./settings.nix

    ./start.nix
  ];

  users.users.${vars.user.name}.packages = [ package.sway ];
}

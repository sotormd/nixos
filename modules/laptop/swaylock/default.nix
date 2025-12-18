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
  ];

  users.users.${vars.user.name}.packages = [ package.swaylock ];
}

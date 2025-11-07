{
  lib,
  pkgs,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  package = import ./package.nix {
    inherit
      lib
      pkgs
      colors
      wallpapers
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

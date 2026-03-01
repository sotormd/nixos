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
  imports = [
    ./opengl.nix

    ./ozone.nix

    ./polkit.nix

    ./screensharing.nix

    ./start.nix
  ];

  users.users.${config.vars.user.name}.packages = [ package.swayWrapped ];
}

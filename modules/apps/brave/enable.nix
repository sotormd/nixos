{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit
    (import ./package.nix {
      inherit
        config
        inputs
        lib
        pkgs
        ;
    })
    brave
    ;
in
{
  users.users.${config.vars.user.name}.packages = [ brave ];
}

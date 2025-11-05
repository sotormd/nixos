{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [ ./github.nix ]

    (lib.optional vars.network.server.enable ./server.nix)
  ];
}

{ config, lib, ... }:

let
  text = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [
      (lib.optional config.vars.features.selfhosted.enable "nameserver ${config.vars.network.server.address}")
      [ "nameserver 1.1.1.1" ]
      [ "nameserver 1.0.0.1" ]
    ]
  );
in
{
  environment.etc."resolv.conf".text = text;
}

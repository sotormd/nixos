{ config, lib, ... }:

let
  text = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [
      (lib.optional config.vars.services.unbound.enable "nameserver 127.0.0.1")
      [ "nameserver 1.1.1.1" ]
      [ "nameserver 1.0.0.1" ]
    ]
  );
in
{
  environment.etc."resolv.conf".text = text;
}

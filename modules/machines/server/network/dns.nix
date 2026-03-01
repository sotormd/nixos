{ config, lib, ... }:

{
  networking.nameservers = lib.concatMap (x: x) [
    (lib.optional config.vars.services.unbound.enable "127.0.0.1")
    [
      "1.1.1.1"
      "1.0.0.1"
    ]
  ];
}

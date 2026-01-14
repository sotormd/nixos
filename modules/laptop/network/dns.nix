{ config, lib, ... }:

{
  networking.nameservers = lib.concatMap (x: x) [
    (lib.optional config.vars.network.server.enable config.vars.network.server.ip)
    [
      "1.1.1.1"
      "1.0.0.1"
    ]
  ];
}

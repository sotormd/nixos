{ config, lib, ... }:

{
  networking.nameservers = lib.concatMap (x: x) [
    (lib.optional config.vars.features.selfhosted.enable config.vars.network.server.address)
    [
      "1.1.1.1"
      "1.0.0.1"
    ]
  ];
}

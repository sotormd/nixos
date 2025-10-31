{ lib, vars, ... }:

{
  networking.nameservers = lib.concatMap (x: x) [
    (lib.optional vars.network.server.enable vars.network.server.ip)
    [
      "1.1.1.1"
      "1.0.0.1"
    ]
  ];
}

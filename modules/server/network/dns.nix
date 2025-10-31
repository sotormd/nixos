{ lib, vars, ... }:

{
  networking.nameservers = lib.concatMap (x: x) [
    (lib.optional vars.network.unbound.enable "127.0.0.1")
    [
      "1.1.1.1"
      "1.0.0.1"
    ]
  ];
}

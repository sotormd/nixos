{
  inputs,
  self,
  config,
  lib,
  ...
}:

let

  # TODO: port forwarding

  index = 10;
  name = "unbound";

  modules = [ self.nixosModules.modules.services.unbound ];

  svcvm = {
    vms = false;
    unbound =
      let
        inherit (config.vars.services) unbound;
      in
      {
        inherit (unbound) enable local-data;
        ifaces = [
          "10.0.${toString index}.100"
          "127.0.0.1"
        ];
        access-control = [
          "${unbound.allow} allow"
          "10.0.${toString index}.1/32 allow"
        ];
      };
  };

  svcvm-guest = {
    inherit index name;
    debug = true;
    resolver = "127.0.0.1";
  };

in
lib.mksvcvm {
  inherit
    inputs
    self
    config
    lib
    index
    name
    modules
    svcvm
    svcvm-guest
    ;
}

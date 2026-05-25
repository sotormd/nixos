{
  inputs,
  self,
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    addresses
    gateways
    ifaces
    ids
    ;

  unbound = {
    svcvm = {
      network = {
        iface = ifaces.unbound;
        gateway = gateways.unbound;
        address = addresses.unbound;
        resolver = "127.0.0.1";
      };
      vm = {
        name = "unbound";
        modules = [
          self.nixosModules.profiles.svcvm
          self.nixosModules.modules.svcvm.unbound
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "unbound-data";
            source = "/var/lib/unbound";
            mountPoint = "/var/lib/unbound";
          }
        ];
        vsock-cid = 3;
      };
      debug = true;
    };
    svcfg.unbound =
      let
        inherit (config.vars.services) unbound;
      in
      {
        inherit (unbound) local-data;
        interfaces = [
          addresses.unbound
          "127.0.0.1"
        ];
        private-address = unbound.allow;
        access-control = [
          "${unbound.allow} allow"
          "${gateways.unbound}/32 allow"
          "${addresses.i2pd}/32 allow"
        ];
      };
  };

in
lib.mkIf config.vars.services.unbound.enable (
  lib.mkMerge [
    (lib.mksvcvm {
      inherit (unbound) svcvm svcfg;
      inherit
        inputs
        self
        pkgs
        lib
        ;
    })
    {
      systemd.tmpfiles.rules = [
        "d /var/lib/unbound 700 ${toString ids.unbound} ${toString ids.unbound} -"
      ];
    }
  ]
)

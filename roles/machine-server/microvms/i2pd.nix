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

  i2pd = {
    svcvm = {
      network = {
        iface = ifaces.i2pd;
        gateway = gateways.i2pd;
        address = addresses.i2pd;
        resolver = if config.vars.services.unbound.enable then addresses.unbound else "1.1.1.1";
      };
      vm = {
        name = "i2pd";
        modules = [
          self.nixosModules.profiles.svcvm
          self.nixosModules.modules.svcvm.i2pd
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "i2pd-data";
            source = "/var/lib/i2pd";
            mountPoint = "/var/lib/i2pd";
          }
        ];
        vsock-cid = 7;
      };
      debug = true;
    };
    svcfg.i2pd =
      let
        inherit (config.vars.services) nginx;
      in
      {
        sam-address = addresses.i2pd;
        httpProxy-address = addresses.i2pd;
        socksProxy-address = addresses.i2pd;
        http-address = addresses.i2pd;
        http-hostname = nginx.domain;
      };
  };

in
lib.mkIf config.vars.services.i2pd.enable (
  lib.mkMerge [
    (lib.mksvcvm {
      inherit (i2pd) svcvm svcfg;
      inherit
        inputs
        self
        pkgs
        lib
        ;
    })
    {
      systemd.tmpfiles.rules = [
        "d /var/lib/i2pd 700 ${toString ids.i2pd} ${toString ids.i2pd} -"
      ];
    }
  ]
)

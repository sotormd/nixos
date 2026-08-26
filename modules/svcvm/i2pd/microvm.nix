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
    ports
    addresses
    gateways
    ifaces
    vsocks
    ids
    ;

  i2pd = {
    svcvm = {
      network = {
        iface = ifaces.i2pd;
        gateway = gateways.i2pd;
        address = addresses.i2pd;
        vsock = vsocks.i2pd;
        resolver = gateways.i2pd;
      };
      tmpfiles = [
        "d /var/lib/i2pd 700 ${toString ids.i2pd} ${toString ids.i2pd} -"
      ];
      secrets = { };
      vm = {
        name = "i2pd";
        modules = [
          ./options.nix
          ./settings.nix
        ];
        shares = [
          {
            tag = "i2pd-data";
            source = "/var/lib/i2pd";
            mountPoint = "/var/lib/i2pd";
          }
        ];
        creds = { };
      };
      debug = config.vars.services.i2pd.debug;
    };
    svcfg.i2pd =
      let
        inherit (config.vars.services) nginx;
      in
      {
        id = ids.i2pd;
        sam = {
          address = addresses.i2pd;
          port = ports.i2pd.sam;
        };
        http-proxy = {
          address = addresses.i2pd;
          port = ports.i2pd.http-proxy;
        };
        web-console = {
          address = addresses.i2pd;
          port = ports.i2pd.web-console;
          hostname = nginx.domain;
        };
      };
  };

in
lib.mkIf config.vars.services.i2pd.enable (
  lib.mksvcvm {
    inherit (i2pd) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

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

  qbt = {
    svcvm = {
      network = {
        iface = ifaces.qbt;
        gateway = gateways.qbt;
        address = addresses.qbt;
        vsock = vsocks.qbt;
        resolver = "127.0.0.1";
      };
      tmpfiles = [
        "d /var/lib/qbt 700 ${toString ids.qbt} ${toString ids.qbt} -"
        "d /srv/torrents 750 ${toString ids.qbt} ${toString ids.qbt} -"
      ];
      secrets = { };
      vm = {
        name = "qbt";
        modules = [
          ./options.nix
          ./service.nix
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "qbt-data";
            source = "/var/lib/qbt";
            mountPoint = "/var/lib/qbt";
          }
          {
            proto = "virtiofs";
            tag = "qbt-torrents";
            source = "/srv/torrents";
            mountPoint = "/srv/torrents";
          }
        ];
        creds = { };
      };
      debug = config.vars.services.qbt.debug;
    };
    svcfg.qbt = {
      id = ids.qbt;
      address = addresses.qbt;
      port = ports.qbt.web-ui;
      i2p = {
        address = addresses.i2pd;
        sam-port = ports.i2pd.sam;
        http-proxy-port = ports.i2pd.http-proxy;
      };
    };
  };

in
lib.mkIf config.vars.services.qbt.enable (
  lib.mksvcvm {
    inherit (qbt) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

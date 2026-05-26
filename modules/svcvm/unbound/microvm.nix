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

  unbound = {
    svcvm = {
      network = {
        iface = ifaces.unbound;
        gateway = gateways.unbound;
        address = addresses.unbound;
        vsock = vsocks.unbound;
        resolver = "127.0.0.1";
      };
      tmpfiles = [
        "d /var/lib/unbound 700 ${toString ids.unbound} ${toString ids.unbound} -"
      ];
      secrets = { };
      vm = {
        name = "unbound";
        modules = [
          ./adblock.nix
          ./options.nix
          ./settings.nix
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "unbound-data";
            source = "/var/lib/unbound";
            mountPoint = "/var/lib/unbound";
          }
        ];
        creds = { };
      };
      debug = true;
    };
    svcfg.unbound =
      let
        inherit (config.vars.services)
          unbound
          nginx
          searxng
          i2pd
          ;
      in
      {
        inherit (unbound) local-data;
        id = ids.unbound;
        interface = [
          addresses.unbound
          "127.0.0.1"
        ];
        port = ports.unbound.dns;
        private-address = unbound.allow;
        access-control = lib.flatten [
          "${unbound.allow} allow"
          "${gateways.unbound}/32 allow"
          (lib.optional nginx.enable "${addresses.nginx}/32 allow")
          (lib.optional searxng.enable "${addresses.searxng}/32 allow")
          (lib.optional i2pd.enable "${addresses.i2pd}/32 allow")
        ];
      };
  };

in
lib.mkIf config.vars.services.unbound.enable (
  lib.mksvcvm {
    inherit (unbound) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

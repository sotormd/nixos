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

  nginx = {
    svcvm = {
      network = {
        iface = ifaces.nginx;
        gateway = gateways.nginx;
        address = addresses.nginx;
        vsock = vsocks.nginx;
        resolver = if config.vars.services.unbound.enable then addresses.unbound else "1.1.1.1";
      };
      tmpfiles = [
        "d /var/lib/acme 750 ${toString ids.acme} ${toString ids.acme} -"
        "d /srv/static 755 root root -"
      ];
      secrets = {
        duckdns = {
          owner = "microvm";
          group = "kvm";
        };
      };
      vm = {
        name = "nginx";
        modules = [
          ./acme.nix
          ./home.nix
          ./locations.nix
          ./options.nix
          ./settings.nix
          ./staging.nix
        ];
        shares = lib.flatten [
          {
            proto = "virtiofs";
            tag = "acme-data";
            source = "/var/lib/acme";
            mountPoint = "/var/lib/acme";
          }
          {
            proto = "virtiofs";
            tag = "static-data";
            source = "/srv/static";
            mountPoint = "/srv/static";
          }
          (lib.optional config.vars.services.qbt.enable {
            proto = "virtiofs";
            tag = "qbt-data";
            source = "/srv/torrents";
            mountPoint = "/srv/torrents";
            readOnly = true;
          })
        ];
        creds = {
          "duckdns" = config.sops.secrets.duckdns.path;
        };
      };
      debug = true;
    };
    svcfg.nginx =
      let
        inherit (config.vars.services)
          nginx
          searxng
          vaultwarden
          i2pd
          qbt
          ;
      in
      {
        inherit (nginx) domain email staging;
        acme-id = ids.acme;
        qbt-id = ids.qbt;
        addr = addresses.nginx;
        port = ports.nginx.https;
        locations = {
          searxng = {
            inherit (searxng) enable allow;
            address = addresses.searxng;
            port = ports.searxng.search-engine;
          };
          vaultwarden = {
            inherit (vaultwarden) enable allow;
            address = addresses.vaultwarden;
            port = ports.vaultwarden.web-vault;
          };
          i2pd = {
            inherit (i2pd) enable allow;
            address = addresses.i2pd;
            port = ports.i2pd.web-console;
          };
          qbt = {
            inherit (qbt) enable allow;
            address = addresses.qbt;
            port = ports.qbt.web-ui;
          };
        };
      };
  };

in
lib.mkIf config.vars.services.nginx.enable (
  lib.mksvcvm {
    inherit (nginx) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

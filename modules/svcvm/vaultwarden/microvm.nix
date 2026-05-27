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

  vaultwarden = {
    svcvm = {
      network = {
        iface = ifaces.vaultwarden;
        gateway = gateways.vaultwarden;
        address = addresses.vaultwarden;
        vsock = vsocks.vaultwarden;
        resolver = "127.0.0.1";
      };
      tmpfiles = [
        "d /var/lib/bitwarden_rs 700 ${toString ids.vaultwarden} ${toString ids.vaultwarden} -"
      ];
      secrets = { };
      vm = {
        name = "vaultwarden";
        modules = [
          ./options.nix
          ./settings.nix
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "vaultwarden-data";
            source = "/var/lib/bitwarden_rs";
            mountPoint = "/var/lib/bitwarden_rs";
          }
        ];
        creds = { };
      };
      debug = true;
    };
    svcfg.vaultwarden =
      let
        inherit (config.vars.services) nginx vaultwarden;
      in
      {
        inherit (nginx) domain;
        inherit (vaultwarden) signups;
        id = ids.vaultwarden;
        address = addresses.vaultwarden;
        port = ports.vaultwarden.web-vault;
      };
  };

in
lib.mkIf config.vars.services.vaultwarden.enable (
  lib.mksvcvm {
    inherit (vaultwarden) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

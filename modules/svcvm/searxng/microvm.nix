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
    ;

  searxng = {
    svcvm = {
      network = {
        iface = ifaces.searxng;
        gateway = gateways.searxng;
        address = addresses.searxng;
        vsock = vsocks.searxng;
        resolver = if config.vars.services.unbound.enable then addresses.unbound else "1.1.1.1";
      };
      tmpfiles = [ ];
      secrets = {
        searxng = {
          owner = "microvm";
          group = "kvm";
        };
      };
      vm = {
        name = "searxng";
        modules = [
          ./engines.nix
          ./options.nix
          ./settings.nix
        ];
        shares = [ ];
        creds = {
          "searxng" = config.sops.secrets.searxng.path;
        };
      };
      debug = config.vars.services.searxng.debug;
    };
    svcfg.searxng =
      let
        inherit (config.vars.services) nginx;
      in
      {
        inherit (nginx) domain;
        bind_address = addresses.searxng;
        port = ports.searxng.search-engine;
      };
  };

in
lib.mkIf config.vars.services.searxng.enable (
  lib.mksvcvm {
    inherit (searxng) svcvm svcfg;
    inherit
      inputs
      self
      pkgs
      lib
      ;
  }
)

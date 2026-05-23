{ config, lib, ... }:

let
  inherit (config.svcfg) unbound;
  inherit (lib) ports;
in
{
  services.unbound.settings.server = {
    interface = unbound.interfaces;
    port = ports.unbound.dns;
  };
}

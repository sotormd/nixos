{ config, lib, ... }:

let
  inherit (config.svcvm) vms unbound;
  inherit (lib) ports;
in
lib.mkIf (unbound.enable && !vms) {

  services.unbound.settings.server = {
    interface = unbound.ifaces;
    port = ports.unbound.dns;
  };

}

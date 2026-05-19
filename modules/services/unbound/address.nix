{ config, lib, ... }:

let
  inherit (config.vars.services) unbound;
  inherit (lib) ports;
in
lib.mkIf unbound.enable {

  services.unbound.settings.server = {
    interface = [
      config.vars.wireless.address
      "127.0.0.1"
    ];
    port = ports.unbound.dns;
  };

}

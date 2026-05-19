{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
  inherit (lib) ports;
in
lib.mkIf nginx.enable {

  services.nginx.virtualHosts.${nginx.domain}.listen = [
    {
      addr = config.vars.wireless.address;
      port = ports.nginx.https;
      ssl = true;
    }
  ];

}

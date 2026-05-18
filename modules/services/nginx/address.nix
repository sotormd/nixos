{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain}.listen = [
      {
        addr = config.vars.wireless.address;
        port = 443;
        ssl = true;
      }
    ];

  };
}

{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain}.listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
    ];

  };
}

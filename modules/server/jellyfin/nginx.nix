{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.jellyfin.enable {
    services.nginx.virtualHosts."${config.vars.network.domain}" = {
      locations."/jellyfin" = {
        proxyPass = "http://127.0.0.1:8096";
      };
    };
  };
}

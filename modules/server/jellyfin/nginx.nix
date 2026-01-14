{ config, lib, ... }:

{
  config = lib.mkIf config.vars.network.jellyfin.enable {
    services.nginx.virtualHosts."${config.vars.network.duckdns.domain}" = {
      locations."/jellyfin" = {
        proxyPass = "http://127.0.0.1:${toString config.vars.network.jellyfin.port}";
      };
    };
  };
}

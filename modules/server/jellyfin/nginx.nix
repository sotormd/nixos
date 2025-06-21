{ vars, ... }:

{
  services.nginx.virtualHosts."${vars.network.duckdns.domain}" = {
    locations."/jellyfin" = {
      proxyPass = "http://127.0.0.1:${toString vars.network.jellyfin.port}";
    };
  };
}

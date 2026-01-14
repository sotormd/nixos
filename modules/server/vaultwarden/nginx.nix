{ config, lib, ... }:

{
  config = lib.mkIf config.vars.network.vaultwarden.enable {
    services.nginx.virtualHosts."${config.vars.network.duckdns.domain}" = {
      locations."/vaultwarden/" = {
        proxyPass = "http://127.0.0.1:${toString config.vars.network.vaultwarden.port}";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}

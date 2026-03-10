{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.vaultwarden.enable {
    services.nginx.virtualHosts.${config.vars.network.domain} = {
      locations."/vaultwarden/" = {
        proxyPass = "http://127.0.0.1:8222";
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

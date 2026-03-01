{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.qbt.enable {
    services.nginx.virtualHosts."${config.vars.network.domain}" = {
      locations."/qbt/" = {
        proxyPass = "http://127.0.0.1:8080";
        extraConfig = ''
          proxy_set_header Host $proxy_host;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          rewrite ^/qbt(/.*)$ $1 break;
        '';
      };
    };
  };
}

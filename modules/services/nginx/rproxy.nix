{ config, lib, ... }:

let
  inherit (config.vars.services)
    nginx
    searxng
    vaultwarden
    i2pd
    qbt
    jellyfin
    ;
in

{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain}.locations = {

      "/searxng/" = lib.mkIf searxng.enable {
        extraConfig = ''
          allow ${searxng.allow};
          deny all;

          uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
        '';
      };

      "/vaultwarden/" = lib.mkIf vaultwarden.enable {
        proxyPass = "http://127.0.0.1:8222";
        extraConfig = ''
          allow ${vaultwarden.allow};
          deny all;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      "/i2pd/" = lib.mkIf i2pd.enable {
        proxyPass = "http://127.0.0.1:7070";
        extraConfig = ''
          allow ${i2pd.allow};
          deny all;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          sub_filter_once off;
          sub_filter '/?' '/i2pd/?';
          sub_filter 'href="/' 'href="/i2pd/';
          sub_filter 'action="/' 'action="/i2pd/';
          sub_filter 'src="/' 'src="/i2pd/';
        '';
      };

      "/qbt/" = lib.mkIf qbt.enable {
        proxyPass = "http://127.0.0.1:8080";
        extraConfig = ''
          allow ${qbt.allow};
          deny all;

          proxy_set_header Host $proxy_host;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          rewrite ^/qbt(/.*)$ $1 break;
        '';
      };

      "/jellyfin/" = lib.mkIf jellyfin.enable {
        proxyPass = "http://127.0.0.1:8096";
        extraConfig = ''
          allow ${jellyfin.allow};
          deny all;
        '';
      };

    };

  };
}

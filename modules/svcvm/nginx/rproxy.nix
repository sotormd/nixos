{ config, lib, ... }:

let
  inherit (config.svcfg) nginx;
  inherit (config.svcfg.nginx.locations)
    searxng
    vaultwarden
    i2pd
    qbt
    ;
in
{
  services.nginx.virtualHosts.${nginx.domain}.locations = {

    "/searxng/" = lib.mkIf searxng.enable {
      proxyPass = "http://${searxng.address}:${toString searxng.port}";
      extraConfig = ''
        allow ${searxng.allow};
        deny all;
      '';
    };

    "/vaultwarden/" = lib.mkIf vaultwarden.enable {
      proxyPass = "http://${vaultwarden.address}:${toString vaultwarden.port}";
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
      proxyPass = "http://${i2pd.address}:${toString i2pd.port}";
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
      proxyPass = "http://${qbt.address}:${toString qbt.port}";
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

    "/torrents/" = lib.mkIf qbt.enable {
      alias = "/srv/torrents/";
      extraConfig = ''
        allow ${qbt.allow};
        deny all;
        autoindex on;
      '';
    };

  };
}

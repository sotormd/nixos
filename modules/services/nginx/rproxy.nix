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

  inherit (lib) ports;
in
lib.mkIf nginx.enable {

  services.nginx.virtualHosts.${nginx.domain}.locations = {

    "/searxng/" = lib.mkIf searxng.enable {
      proxyPass = "http://127.0.0.1:${toString ports.searxng.search-engine}";
      extraConfig = ''
        allow ${searxng.allow};
        deny all;
      '';
    };

    "/vaultwarden/" = lib.mkIf vaultwarden.enable {
      proxyPass = "http://127.0.0.1:${toString ports.vaultwarden.web-vault}";
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
      proxyPass = "http://127.0.0.1:${toString ports.i2pd.web-console}";
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
      proxyPass = "http://127.0.0.1:${toString ports.qbt.web-ui}";
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
      proxyPass = "http://127.0.0.1:${toString ports.jellyfin.web-interface}";
      extraConfig = ''
        allow ${jellyfin.allow};
        deny all;
      '';
    };

  };

}

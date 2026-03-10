{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.i2pd.enable {
    services.nginx.virtualHosts.${config.vars.network.domain} = {
      locations."/i2pd/" = {
        proxyPass = "http://127.0.0.1:7070";
        extraConfig = ''
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
    };

    services.nginx.virtualHosts.eepsite = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9999;
        }
      ];
      locations."/" = {
        root = "/srv/i2p";
      };
    };
  };
}

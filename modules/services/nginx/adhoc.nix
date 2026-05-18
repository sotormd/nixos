{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain} = {
      locations."~ ^/adhoc/(10[0-9][0-9][0-9])/(.*)$" = {
        proxyPass = "http://127.0.0.1:$1/$2$is_args$args";
      };
    };

  };
}

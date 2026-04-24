{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    services.nginx.virtualHosts.${config.vars.services.nginx.domain} = {
      locations."~ ^/adhoc/(10[0-9][0-9][0-9])/(.*)$" = {
        proxyPass = "http://127.0.0.1:$1/$2$is_args$args";
      };
    };

  };
}

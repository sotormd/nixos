{ config, ... }:

{
  services.nginx.virtualHosts."${config.vars.network.domain}" = {
    locations."~ ^/adhoc/(10[0-9][0-9][0-9])/(.*)$" = {
      proxyPass = "http://127.0.0.1:$1/$2$is_args$args";
    };
  };
}

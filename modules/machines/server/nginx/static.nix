{ config, ... }:

{
  services.nginx.virtualHosts."${config.vars.network.domain}" = {
    locations."/static/" = {
      alias = "/srv/static/";
    };
  };
}

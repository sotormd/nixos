{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    services.nginx.virtualHosts.${config.vars.services.nginx.domain} = {
      locations."/static/" = {
        alias = "/srv/static/";
      };
    };

  };
}

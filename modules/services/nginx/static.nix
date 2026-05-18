{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain} = {
      locations."/static/" = {
        alias = "/srv/static/";
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/static 755 root root -"
      "Z /srv/static - root root -"
    ];

  };
}

{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.searxng.enable {

    users.groups.searx.members = [ "nginx" ];

    services.nginx.virtualHosts.${config.vars.services.nginx.domain} = {
      locations."/searxng/" = {
        extraConfig = ''
          allow ${config.vars.services.searxng.allow};
          deny all;

          uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
        '';
      };
    };

  };
}

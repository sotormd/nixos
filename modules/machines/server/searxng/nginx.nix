{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.searxng.enable {
    users.groups.searx.members = [ "nginx" ];

    services.nginx.virtualHosts.${config.vars.network.domain} = {
      locations."/searxng/" = {
        extraConfig = ''
          uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
        '';
      };
    };
  };
}

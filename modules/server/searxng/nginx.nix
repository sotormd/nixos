{ config, vars, ... }:

{
  users.groups.searx.members = [ "nginx" ];

  services.nginx.virtualHosts."${vars.network.duckdns.domain}" = {
    locations."/searxng/" = {
      extraConfig = ''
        uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
      '';
    };
  };
}

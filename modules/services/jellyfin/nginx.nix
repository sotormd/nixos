{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.jellyfin.enable {

    services.nginx.virtualHosts.${config.vars.services.nginx.domain} = {
      locations."/jellyfin/" = {
        proxyPass = "http://127.0.0.1:8096";
        extraConfig = ''
          allow ${config.vars.services.jellyfin.allow};
          deny all;
        '';
      };
    };

  };
}

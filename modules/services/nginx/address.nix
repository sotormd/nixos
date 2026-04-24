{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    services.nginx.virtualHosts.${config.vars.services.nginx.domain}.listen = [
      {
        addr = config.vars.wireless.address;
        port = 443;
        ssl = true;
      }
    ];

  };
}

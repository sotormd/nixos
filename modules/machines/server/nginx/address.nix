{ config, ... }:

{
  services.nginx.virtualHosts.${config.vars.network.domain}.listen = [
    {
      addr = config.vars.network.address;
      port = 443;
      ssl = true;
    }
  ];
}

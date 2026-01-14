{ config, ... }:

{
  services.nginx.defaultListenAddresses = [ config.vars.network.ip ];
}

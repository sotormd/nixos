{ vars, ... }:

{
  services.nginx.defaultListenAddresses = [ vars.network.ip ];
}

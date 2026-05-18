{ config, ... }:

let
  inherit (config.vars.wireless) interface address gateway;
in
{
  # primary network and static address
  systemd.network.networks."10-primary" = {
    matchConfig.Name = interface;
    address = [ "${address}/24" ];
    routes = [ { Gateway = gateway; } ];
    networkConfig.DHCP = "no";
  };

  networking.useDHCP = false;
}

{ config, lib, ... }:

let
  inherit (config.vars.network.wireless)
    enable
    interface
    address
    gateway
    ;
in
lib.mkIf enable {
  # primary network and static address
  systemd.network.networks."10-primary" = {
    matchConfig.Name = interface;
    address = [ "${address}/24" ];
    routes = [ { Gateway = gateway; } ];
    networkConfig.DHCP = "no";
  };
}

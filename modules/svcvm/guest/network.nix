{ config, ... }:

let
  inherit (config.svcvm-guest) index name;
in
{
  networking.hostName = "${toString index}-${name}";
  microvm.interfaces = [
    {
      id = "svcvm${toString index}";
      type = "tap";
      mac = "00:00:00:00:00:01";
    }
  ];
  systemd.network.networks."10-eth" = {
    matchConfig.MACAddress = "00:00:00:00:00:01";
    address = [ "10.0.${toString index}.100/32" ];
    routes = [
      {
        Destination = "10.0.${toString index}.1/32";
        GatewayOnLink = true;
      }
      {
        Destination = "0.0.0.0/0";
        Gateway = "10.0.${toString index}.1";
        GatewayOnLink = true;
      }
    ];
  };
}

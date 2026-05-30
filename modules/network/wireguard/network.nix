{ config, lib, ... }:

let
  inherit (config.vars) wireguard;
  inherit (lib) ifaces;
in
{
  systemd.network.networks."50-wireguard" = {
    matchConfig.Name = ifaces.wireguard;
    address = [ "${wireguard.address}/32" ];
    networkConfig = lib.mkIf wireguard.forwarding {
      IPv4Forwarding = true;
      IPv6Forwarding = false;
    };
  };
}

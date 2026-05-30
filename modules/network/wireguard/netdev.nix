{ config, lib, ... }:

let
  inherit (config.vars) wireguard;
  inherit (lib) ifaces;
in
{
  systemd.network.netdevs."50-wireguard" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = ifaces.wireguard;
    };
    wireguardConfig = {
      ListenPort = wireguard.port;
      PrivateKeyFile = config.sops.secrets.wireguard.path;
      RouteTable = "main";
    };
    wireguardPeers = wireguard.peers;
  };
}

{ config, lib, ... }:

let
  inherit (config.vars.network) wireguard;
  inherit (lib) ifaces;
in
lib.mkIf wireguard.enable {
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

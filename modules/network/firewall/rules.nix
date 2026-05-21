{ config, lib, ... }:

let
  inherit (config.vars.wireless) interface address;

  inherit (lib) ports;

  inherit (config.vars.services)
    ssh
    unbound
    nginx
    searxng
    vaultwarden
    i2pd
    qbt
    jellyfin
    ;

  o = lib.optionalString;

  services = lib.concatStringsSep "\n" (
    lib.filter (s: s != "") [

      ####################################################################################################################################################################
      #
      # LOOPBACK PORTS
      #

      #
      # openssh secure shell daemon
      #

      (o ssh.enable "ip saddr ${ssh.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ssh.port} accept")

      #
      # unbound validating recursive dns server
      #

      (o unbound.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.unbound.dns} accept")

      (o unbound.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" udp dport ${toString ports.unbound.dns} accept")

      #
      # searxng metasearch engine
      #

      (o searxng.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.searxng.search-engine} accept")

      #
      # vaultwarden password manager
      #

      (o vaultwarden.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.vaultwarden.web-vault} accept")

      #
      # i2pd invisible internet protocol daemon
      #

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.sam} accept")

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.socks-proxy} accept")

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.web-console} accept")

      #
      # qbittorrent bittorrent client
      #

      (o qbt.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.qbt.web-ui} accept")

      #
      # jellyfin media server
      #

      (o jellyfin.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.jellyfin.web-interface} accept")

      ####################################################################################################################################################################
      #
      # LAN PORTS
      #

      #
      # unbound validating recursive dns server
      #

      (o unbound.enable "ip saddr ${unbound.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.unbound.dns} accept")

      (o unbound.enable "ip saddr ${unbound.allow} ip daddr ${address} iifname \"${interface}\" udp dport ${toString ports.unbound.dns} accept")

      #
      # nginx web server
      #

      (o nginx.enable "ip saddr ${nginx.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.nginx.https} accept")

      #
      # i2pd invisible internet protocol daemon
      #

      (o i2pd.enable "ip saddr ${i2pd.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.i2pd.http-proxy} accept")

    ]
  );
in
{
  networking.nftables.ruleset = lib.mkForce ''
    flush ruleset
    table inet filter {
        chain input {
            type filter hook input priority filter; policy drop;
            ct state invalid drop
            tcp flags & (fin|syn|rst|ack) != syn ct state new drop

            iifname "${interface}" ct state established,related accept
            iifname "lo" ct state established,related accept
            ${services}
        }

        chain forward {
            type filter hook forward priority filter; policy drop;
        }

        chain output {
            type filter hook output priority filter; policy accept;
        }
    }
  '';
}

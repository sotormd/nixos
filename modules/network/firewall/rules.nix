####################################################
# The following ports are required:
#
# 1. openssh: secure shell daemon
#
#    IF: vars.services.ssh.enable
#
#    LAN ports TO vars.services.ssh.allow:
#      vars.services.ssh.port
#    lo  ports TO 127.0.0.1:
#      -
#
# 2. unbound: validating recursive dns server
#
#    IF: vars.services.unbound.enable
#
#    LAN ports TO vars.services.unbound.allow:
#      53/tcp
#      53/udp
#    lo  ports TO 127.0.0.1:
#      53/tcp
#      53/udp
#
# 3. nginx: web server
#
#    IF: vars.services.nginx.enable
#
#    LAN ports TO vars.services.nginx.allow:
#      443
#    lo  ports TO 127.0.0.1:
#      -
#
# 4. searxng: metasearch engine
#
#    IF: vars.services.searxng.enable
#
#    LAN ports TO vars.services.searxng.allow:
#      -
#    lo  ports TO 127.0.0.1:
#      8888
#
# 5. vaultwarden: password manager
#
#    IF: vars.services.vaultwarden.enable
#
#    LAN ports TO vars.services.vaultwarden.allow:
#      -
#    lo  ports TO 127.0.0.1:
#      8222
#
# 6. i2pd: invisible internet protocol daemon
#
#    IF: vars.services.i2pd.enable
#
#    LAN ports TO vars.services.i2pd.allow:
#      4444
#    lo  ports TO 127.0.0.1:
#      7656
#      4447
#      7070
#
# 7. qbittorrent: bittorrent client
#
#    IF: vars.services.qbt.enable
#
#    LAN ports TO vars.services.qbt.allow:
#      -
#    lo  ports TO 127.0.0.1:
#      8080
#
# 8. jellyfin: media server
#
#    IF: vars.services.jellyfin.enable
#
#    LAN ports TO vars.services.jellyfin.allow:
#      -
#    lo  ports TO 127.0.0.1:
#      8096
#

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
in
{
  networking.firewall = {

    ###########
    # deny all
    ###########

    # disallow pings
    allowPing = false;

    # trust no interfaces
    trustedInterfaces = lib.mkForce [ ];

    # open zero ports
    allowedTCPPorts = lib.mkForce [ ];
    allowedUDPPorts = lib.mkForce [ ];
    allowedTCPPortRanges = lib.mkForce [ ];
    allowedUDPPortRanges = lib.mkForce [ ];

    # log refused
    logRefusedConnections = true;
    logRefusedPackets = true;

    #############
    # open ports
    #############

    extraInputRules = lib.concatStringsSep "\n" [

      ####################################################################################################################################################################
      #
      # openssh secure shell daemon
      #

      (o ssh.enable "ip saddr ${ssh.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ssh.port} accept")

      ####################################################################################################################################################################
      #
      # unbound validating recursive dns server
      #

      (o unbound.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.unbound.dns} accept")

      (o unbound.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" udp dport ${toString ports.unbound.dns} accept")

      (o unbound.enable "ip saddr ${unbound.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.unbound.dns} accept")

      (o unbound.enable "ip saddr ${unbound.allow} ip daddr ${address} iifname \"${interface}\" udp dport ${toString ports.unbound.dns} accept")

      ####################################################################################################################################################################
      #
      # nginx web server
      #

      (o nginx.enable "ip saddr ${nginx.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.nginx.https} accept")

      ####################################################################################################################################################################
      #
      # searxng metasearch engine
      #

      (o searxng.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.searxng.search-engine} accept")

      ####################################################################################################################################################################
      #
      # vaultwarden password manager
      #

      (o vaultwarden.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.vaultwarden.web-vault} accept")

      ####################################################################################################################################################################
      #
      # i2pd invisible internet protocol daemon
      #

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.sam} accept")

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.socks-proxy} accept")

      (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.web-console} accept")

      (o i2pd.enable "ip saddr ${i2pd.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.i2pd.http-proxy} accept")

      ####################################################################################################################################################################
      #
      # qbittorrent bittorrent client
      #

      (o qbt.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.qbt.web-ui} accept")

      ####################################################################################################################################################################
      #
      # jellyfin media server
      #

      (o jellyfin.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.jellyfin.web-interface} accept")

    ];

  };
}

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
#    LAN ports TO vars.services.jellyfin.enable:
#      -
#    lo  ports TO 127.0.0.1:
#      8096
#
####################################################

{ config, lib, ... }:

let
  inherit (config.vars.wireless) interface address;

  inherit (lib.ports) internal external;

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
in
{
  ###########
  # deny all
  ###########

  # disallow pings
  networking.firewall.allowPing = false;

  # trust no interfaces
  networking.firewall.trustedInterfaces = lib.mkForce [ ];

  # open zero ports
  networking.firewall.allowedTCPPorts = lib.mkForce [ ];
  networking.firewall.allowedUDPPorts = lib.mkForce [ ];
  networking.firewall.allowedTCPPortRanges = lib.mkForce [ ];
  networking.firewall.allowedUDPPortRanges = lib.mkForce [ ];

  #############
  # open ports
  #############

  networking.firewall.extraCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -A nixos-fw -p tcp --source ${ssh.allow} -d ${address} -i ${interface} --dport ${toString ssh.port} -j nixos-fw-accept")

    # unbound validating recursive dns server
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.unbound.dns} -j nixos-fw-accept")
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p udp -d 127.0.0.1 -i lo --dport ${toString internal.unbound.dns} -j nixos-fw-accept")
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p tcp --source ${unbound.allow} -d ${address} -i ${interface} --dport ${toString external.unbound.dns} -j nixos-fw-accept")
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p udp --source ${unbound.allow} -d ${address} -i ${interface} --dport ${toString external.unbound.dns} -j nixos-fw-accept")

    # nginx web server
    (lib.optionalString nginx.enable "iptables -A nixos-fw -p tcp --source ${nginx.allow} -d ${address} -i ${interface} --dport ${toString external.nginx.https} -j nixos-fw-accept")

    # searxng metasearch engine
    (lib.optionalString searxng.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.searxng.search-engine} -j nixos-fw-accept")

    # vaultwarden password manager
    (lib.optionalString vaultwarden.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.vaultwarden.webvault} -j nixos-fw-accept")

    # i2pd invisible internet protocol daemon
    (lib.optionalString i2pd.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.sam} -j nixos-fw-accept")
    (lib.optionalString i2pd.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.socks} -j nixos-fw-accept")
    (lib.optionalString i2pd.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.webconsole} -j nixos-fw-accept")
    (lib.optionalString i2pd.enable "iptables -A nixos-fw -p tcp --source ${i2pd.allow} -d ${address} -i ${interface} --dport ${toString external.i2pd.http} -j nixos-fw-accept")

    # qbittorrent bittorrent client
    (lib.optionalString qbt.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.qbt.webui} -j nixos-fw-accept")

    # jellyfin media server
    (lib.optionalString jellyfin.enable "iptables -A nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.jellyfin.web-interface} -j nixos-fw-accept")

  ];

  networking.firewall.extraStopCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -D nixos-fw -p tcp --source ${ssh.allow} -d ${address} -i ${interface} --dport ${toString ssh.port} -j nixos-fw-accept || true")

    # unbound validating recursive dns server
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.unbound.dns} -j nixos-fw-accept || true")
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p udp -d 127.0.0.1 -i lo --dport ${toString internal.unbound.dns} -j nixos-fw-accept || true")
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p tcp --source ${unbound.allow} -d ${address} -i ${interface} --dport ${toString external.unbound.dns} -j nixos-fw-accept || true")
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p udp --source ${unbound.allow} -d ${address} -i ${interface} --dport ${toString external.unbound.dns} -j nixos-fw-accept || true")

    # nginx web server
    (lib.optionalString nginx.enable "iptables -D nixos-fw -p tcp --source ${nginx.allow} -d ${address} -i ${interface} --dport ${toString external.nginx.https} -j nixos-fw-accept || true")

    # searxng metasearch engine
    (lib.optionalString searxng.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.searxng.search-engine} -j nixos-fw-accept || true")

    # vaultwarden password manager
    (lib.optionalString vaultwarden.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.vaultwarden.webvault} -j nixos-fw-accept || true")

    # i2pd invisible internet protocol daemon
    (lib.optionalString i2pd.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.sam} -j nixos-fw-accept || true")
    (lib.optionalString i2pd.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.socks} -j nixos-fw-accept || true")
    (lib.optionalString i2pd.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.i2pd.webconsole} -j nixos-fw-accept || true")
    (lib.optionalString i2pd.enable "iptables -D nixos-fw -p tcp --source ${i2pd.allow} -d ${address} -i ${interface} --dport ${toString external.i2pd.http} -j nixos-fw-accept || true")

    # qbittorrent bittorrent client
    (lib.optionalString qbt.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.qbt.webui} -j nixos-fw-accept || true")

    # jellyfin media server
    (lib.optionalString jellyfin.enable "iptables -D nixos-fw -p tcp -d 127.0.0.1 -i lo --dport ${toString internal.jellyfin.web-interface} -j nixos-fw-accept || true")

  ];
}

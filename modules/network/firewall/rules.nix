####################################################
# The following ports are required:
#
# 1. openssh: secure shell daemon
#
#    IF: vars.services.ssh.enable
#
#    LAN ports TO vars.services.ssh.allow:
#      vars.services.ssh.port
#    lo  ports:
#      -
#
# 2. unbound: validating recursive dns server
#
#    IF: vars.services.unbound.enable
#
#    LAN ports TO vars.services.unbound.allow:
#      53/tcp
#      53/udp
#    lo  ports:
#      53/tcp
#      53/udp
#
# 3. vaultwarden: password manager
#
#    IF: vars.services.vaultwarden.enable
#
#    LAN ports TO vars.services.vaultwarden.allow:
#      -
#    lo  ports:
#      8222
#
# 4. i2pd: invisible internet protocol daemon
#
#    IF: vars.services.i2pd.enable
#
#    LAN ports TO vars.services.i2pd.allow:
#      4444
#    lo  ports:
#      7656
#      4447
#      7070
#
# 5. qbittorrent: bittorrent client
#
#    IF: vars.services.qbt.enable
#
#    LAN ports TO vars.services.qbt.allow:
#      -
#    lo  ports:
#      8080
#
# 6. jellyfin: media server
#
#    IF: vars.services.jellyfin.enable
#
#    LAN ports TO vars.services.jellyfin.enable:
#      -
#    lo  ports:
#      8096
#
# 7. nginx: web server
#
#    IF: vars.services.nginx.enable
#
#    LAN ports TO vars.services.nginx.allow:
#      443
#    lo  ports:
#      -
#
####################################################

{ config, lib, ... }:

let
  inherit (config.vars.services)
    ssh
    unbound
    nginx
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

  #################
  # loopback ports
  #################

  networking.firewall.interfaces.lo.allowedTCPPorts = lib.flatten [

    # unbound validating recursive dns server
    (lib.optional unbound.enable 53)

    # vaultwarden password manager
    (lib.optional vaultwarden.enable 8222)

    # i2pd invisible internet protocol daemon
    (lib.optionals i2pd.enable [
      7656
      4447
      7070
    ])

    # qbittorrent bittorrent client
    (lib.optional qbt.enable 8080)

    # jellyfin media server
    (lib.optional jellyfin.enable 8096)
  ];

  networking.firewall.interfaces.lo.allowedUDPPorts = lib.flatten [

    # unbound validating recursive dns server
    (lib.optional unbound.enable 53)

  ];

  ############
  # LAN ports
  ############

  networking.firewall.extraCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -A nixos-fw -p tcp --source ${ssh.allow} --dport ${toString ssh.port} -j nixos-fw-accept")

    # unbound validating recursive dns server
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p tcp --source ${unbound.allow} --dport 53 -j nixos-fw-accept")
    (lib.optionalString unbound.enable "iptables -A nixos-fw -p udp --source ${unbound.allow} --dport 53 -j nixos-fw-accept")

    # nginx web server
    (lib.optionalString nginx.enable "iptables -A nixos-fw -p tcp --source ${nginx.allow} --dport 443 -j nixos-fw-accept")

    # i2pd invisible internet protocol daemon
    (lib.optionalString i2pd.enable "iptables -A nixos-fw -p tcp --source ${i2pd.allow} --dport 4444 -j nixos-fw-accept")

  ];

  networking.firewall.extraStopCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -D nixos-fw -p tcp --source ${ssh.allow} --dport ${toString ssh.port} -j nixos-fw-accept || true")

    # unbound validating recursive dns server
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p tcp --source ${unbound.allow} --dport 53 -j nixos-fw-accept || true")
    (lib.optionalString unbound.enable "iptables -D nixos-fw -p udp --source ${unbound.allow} --dport 53 -j nixos-fw-accept || true")

    # nginx web server
    (lib.optionalString nginx.enable "iptables -D nixos-fw -p tcp --source ${nginx.allow} --dport 443 -j nixos-fw-accept || true")

    # i2pd invisible internet protocol daemon
    (lib.optionalString i2pd.enable "iptables -D nixos-fw -p tcp --source ${i2pd.allow} --dport 4444 -j nixos-fw-accept || true")

  ];
}

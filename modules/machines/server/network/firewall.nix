####################################################
# The following ports are required:
#
# 1. sshd: secure shell daemon
#
#    LAN ports:
#      config.vars.network.ssh.port
#    lo  ports: -
#
# 2. unbound: validating recursive dns server
#
#    LAN ports:
#      53/tcp
#      53/udp
#    lo  ports:
#      53/tcp
#      53/udp
#
# 3. vaultwarden: password manager
#
#    LAN ports: -
#    lo  ports:
#      8222
#
# 4. i2pd: invisible internet protocol daemon
#
#    LAN ports:
#      4444
#    lo  ports:
#      7656
#      4447
#      7070
#      9999
#
# 5. qbittorrent: bittorrent client
#
#    LAN ports: -
#    lo  ports:
#      8080
#
# 6. jellyfin: media server
#
#    LAN ports: -
#    lo  ports:
#      8096
#
# 7. nginx: web server
#
#    LAN ports:
#      443
#    lo  ports: -
#
####################################################

{ config, lib, ... }:

{
  ######################
  # trust no interfaces
  ######################
  networking.firewall.trustedInterfaces = lib.mkForce [ ];

  #################
  # loopback ports
  #################

  networking.firewall.interfaces.lo.allowedTCPPorts = lib.concatMap (x: x) [

    # unbound validating recursive dns server
    (lib.optional config.vars.services.unbound.enable 53)

    # vaultwarden password manager
    (lib.optional config.vars.services.vaultwarden.enable 8222)

    # i2pd invisible internet protocol daemon
    (lib.optional config.vars.services.i2pd.enable 7656)
    (lib.optional config.vars.services.i2pd.enable 4447)
    (lib.optional config.vars.services.i2pd.enable 7070)
    (lib.optional config.vars.services.i2pd.enable 9999)

    # qbittorrent bittorrent client
    (lib.optional config.vars.services.qbt.enable 8080)

    # jellyfin media server
    (lib.optional config.vars.services.jellyfin.enable 8096)
  ];

  networking.firewall.interfaces.lo.allowedUDPPorts = lib.concatMap (x: x) [

    # unbound validating recursive dns server
    (lib.optional config.vars.services.unbound.enable 53)
  ];

  ############
  # LAN ports
  ############

  networking.firewall.extraCommands = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [

      # sshd secure shell daemon
      [
        "iptables -A nixos-fw -p tcp --source ${config.vars.network.range} --dport ${toString config.vars.network.ssh.port} -j nixos-fw-accept"
      ]

      # unbound validating recursive dns server
      (lib.optional config.vars.services.unbound.enable "iptables -A nixos-fw -p tcp --source ${config.vars.network.range} --dport 53 -j nixos-fw-accept")

      (lib.optional config.vars.services.unbound.enable "iptables -A nixos-fw -p udp --source ${config.vars.network.range} --dport 53 -j nixos-fw-accept")

      # nginx web server
      (lib.optional config.vars.services.nginx.enable "iptables -A nixos-fw -p tcp --source ${config.vars.network.range} --dport 443 -j nixos-fw-accept")

      # i2pd invisible internet protocol daemon
      (lib.optional config.vars.services.i2pd.enable "iptables -A nixos-fw -p tcp --source ${config.vars.network.range} --dport 4444 -j nixos-fw-accept")
    ]
  );

  networking.firewall.extraStopCommands = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [

      # sshd secure shell daemon
      [
        "iptables -D nixos-fw -p tcp --source ${config.vars.network.range} --dport ${toString config.vars.network.ssh.port} -j nixos-fw-accept || true"
      ]

      # unbound validating recursive dns server
      (lib.optional config.vars.services.unbound.enable "iptables -D nixos-fw -p tcp --source ${config.vars.network.range} --dport 53 -j nixos-fw-accept || true")

      (lib.optional config.vars.services.unbound.enable "iptables -D nixos-fw -p udp --source ${config.vars.network.range} --dport 53 -j nixos-fw-accept || true")

      # nginx web server
      (lib.optional config.vars.services.nginx.enable "iptables -D nixos-fw -p tcp --source ${config.vars.network.range} --dport 443 -j nixos-fw-accept || true")

      # i2pd invisible internet protocol daemon
      (lib.optional config.vars.services.i2pd.enable "iptables -D nixos-fw -p tcp --source ${config.vars.network.range} --dport 4444 -j nixos-fw-accept || true")
    ]
  );
}

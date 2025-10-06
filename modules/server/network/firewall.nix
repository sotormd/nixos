###########################################################################
# The following ports are required:
#
# 1. sshd: secure shell daemon
#
#    LAN ports: vars.network.ssh.port
#    lo  ports: -
#
# 2. unbound: validating recursive dns server
#
#    LAN ports: 53/tcp 53/udp
#    lo  ports: 53/tcp 53/udp
#
# 3. vaultwarden: password manager
#
#    LAN ports: -
#    lo  ports: vars.network.vaultwarden.port
#
# 4. i2pd: invisible internet protocol daemon
#
#    LAN ports: vars.network.i2pd.httpProxy.port
#    lo  ports: vars.network.i2pd.sam.port vars.network.i2pd.socksProxy.port vars.network.webconsole.port
#
# 5. qbittorrent: bittorrent client
#
#    LAN ports: -
#    lo  ports: vars.network.qbt.port
#
# 6. jellyfin: media server
#
#    LAN ports: -
#    lo  ports: vars.network.jellyfin.port
#
# 7. nginx: web server
#
#    LAN ports: 443
#    lo  ports: -
#
###########################################################################

{ lib, vars, ... }:

{
  #################
  # loopback ports
  #################

  networking.firewall.interfaces.lo.allowedTCPPorts = lib.concatMap (x: x) [

    # unbound validating recursive dns server
    (lib.optImport vars.network.unbound.enable 53)

    # vaultwarden password manager
    (lib.optImport vars.network.vaultwarden.enable vars.network.vaultwarden.port)

    # i2pd invisible internet protocol daemon
    (lib.optImport vars.network.i2pd.enable vars.network.i2pd.sam.port)
    (lib.optImport vars.network.i2pd.enable vars.network.i2pd.socksProxy.port)
    (lib.optImport vars.network.i2pd.enable vars.network.i2pd.webconsole.port)

    # qbittorrent bittorrent client
    (lib.optImport vars.network.qbt.enable vars.network.qbt.port)

    # jellyfin media server
    (lib.optImport vars.network.jellyfin.enable vars.network.jellyfin.port)
  ];

  networking.firewall.interfaces.lo.allowedUDPPorts = lib.concatMap (x: x) [

    # unbound validating recursive dns server
    (lib.optImport vars.network.unbound.enable 53)
  ];

  ############
  # LAN ports
  ############

  networking.firewall.extraCommands = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [

      # sshd secure shell daemon
      [
        "iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept"
      ]

      # unbound validating recursive dns server
      (lib.optImport vars.network.unbound.enable "iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept")

      (lib.optImport vars.network.unbound.enable "iptables -A nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept")

      # nginx web server
      (lib.optImport vars.network.nginx.enable "iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept")

      # i2pd invisible internet protocol daemon
      (lib.optImport vars.network.i2pd.enable "iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.i2pd.httpProxy.port} -j nixos-fw-accept")
    ]
  );

  networking.firewall.extraStopCommands = lib.concatStringsSep "\n" (
    lib.concatMap (x: x) [

      # sshd secure shell daemon
      [
        "iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept || true"
      ]

      # unbound validating recursive dns server
      (lib.optImport vars.network.unbound.enable "iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true")

      (lib.optImport vars.network.unbound.enable "iptables -D nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true")

      # nginx web server
      (lib.optImport vars.network.nginx.enable "iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept || true")

      # i2pd invisible internet protocol daemon
      (lib.optImport vars.network.i2pd.enable "iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.i2pd.httpProxy.port} -j nixos-fw-accept || true")
    ]
  );
}

{ vars, ... }:

{
  # loopback ports
  networking.firewall.interfaces.lo.allowedTCPPorts = [
    # unbound
    53

    # vaultwarden
    vars.network.vaultwarden.port

    # i2pd
    vars.network.i2pd.sam.port
    vars.network.i2pd.socksProxy.port
    vars.network.i2pd.webconsole.port

    # qbt
    vars.network.qbt.port

    # jellyfin
    vars.network.jellyfin.port
  ];
  networking.firewall.interfaces.lo.allowedUDPPorts = [
    # unbound
    53
  ];

  # LAN ports
  networking.firewall.extraCommands = ''
    # ssh
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept

    # unbound
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept

    # nginx
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept

    # i2pd
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.i2pd.httpProxy.port} -j nixos-fw-accept
  '';

  networking.firewall.extraStopCommands = ''
    # ssh
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept || true

    # unbound
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true
    iptables -D nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true

    # nginx
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept || true

    # i2pd
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.i2pd.httpProxy.port} -j nixos-fw-accept || true
  '';
}

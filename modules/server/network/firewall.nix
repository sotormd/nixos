{ vars, ... }:

{
  # ports on loopback interface
  networking.firewall.interfaces.lo.allowedTCPPorts = [
    53 # unbound
    vars.network.vaultwarden.port # vaultwarden
  ];
  networking.firewall.interfaces.lo.allowedUDPPorts = [
    53 # unbound
  ];

  # ports on LAN
  networking.firewall.extraCommands = ''
    # ssh
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept

    # unbound
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept

    # nginx
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 80 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept
  '';

  networking.firewall.extraStopCommands = ''
    # ssh
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept || true

    # unbound
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true
    iptables -D nixos-fw -p udp --source ${vars.network.range} --dport 53 -j nixos-fw-accept || true

    # nginx
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 80 -j nixos-fw-accept || true
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport 443 -j nixos-fw-accept || true
  '';
}

{ vars, ... }:

{
  # ssh
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D nixos-fw -p tcp --source ${vars.network.range} --dport ${toString vars.network.ssh.port} -j nixos-fw-accept || true
  '';
}

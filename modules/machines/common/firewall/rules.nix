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
####################################################

{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
{
  # disallow pings
  networking.firewall.allowPing = false;

  # trust no interfaces
  networking.firewall.trustedInterfaces = lib.mkForce [ ];

  # open zero ports
  networking.firewall.allowedTCPPorts = lib.mkForce [ ];
  networking.firewall.allowedUDPPorts = lib.mkForce [ ];
  networking.firewall.allowedTCPPortRanges = lib.mkForce [ ];
  networking.firewall.allowedUDPPortRanges = lib.mkForce [ ];

  ############
  # LAN ports
  ############

  networking.firewall.extraCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -A nixos-fw -p tcp --source ${ssh.allow} --dport ${toString ssh.port} -j nixos-fw-accept")

  ];

  networking.firewall.extraStopCommands = lib.concatStringsSep "\n" [

    # openssh secure shell daemon
    (lib.optionalString ssh.enable "iptables -D nixos-fw -p tcp --source ${ssh.allow} --dport ${toString ssh.port} -j nixos-fw-accept || true")

  ];
}

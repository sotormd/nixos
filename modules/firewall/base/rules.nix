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

{ config, lib, ... }:

let
  inherit (config.vars.wireless) interface address;

  inherit (config.vars.services) ssh;

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

    ];

  };
}

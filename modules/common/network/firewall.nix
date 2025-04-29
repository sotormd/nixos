{ lib, ... }:

{
  # enable firewall
  networking.firewall.enable = true;

  # disallow pings
  networking.firewall.allowPing = false;

  # trust no interfaces
  networking.firewall.trustedInterfaces = lib.mkForce [ ];

  # open zero ports
  networking.firewall.allowedTCPPorts = lib.mkForce [ ];
  networking.firewall.allowedUDPPorts = lib.mkForce [ ];
  networking.firewall.allowedTCPPortRanges = lib.mkForce [ ];
  networking.firewall.allowedUDPPortRanges = lib.mkForce [ ];
}

{ lib, ... }:

{
  # trust only the loopback interface
  networking.firewall.trustedInterfaces = lib.mkForce [ "lo" ];
}

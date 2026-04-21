{ pkgs, ... }:

{
  # enable the new iptables-nft instead of iptables-legacy
  networking.firewall.enable = true;
  networking.firewall.package = pkgs.iptables;
}

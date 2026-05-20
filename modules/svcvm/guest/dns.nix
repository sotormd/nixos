{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.svcvm-guest) resolver;
in
{
  systemd.services.resolved.enable = false;
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = lib.mkForce "nameserver ${resolver}";
  environment.systemPackages = [ pkgs.dig ];
}

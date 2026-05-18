{ config, lib, ... }:

{
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = lib.mkForce "nameserver ${config.vars.wireless.resolver}";
}
